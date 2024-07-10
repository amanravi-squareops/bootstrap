resource "kubernetes_namespace" "atmosly" {
  metadata {
    name = "atmosly"
  }
}

resource "helm_release" "argocd_deploy" {
  depends_on = [kubernetes_namespace.atmosly]
  count      = var.enable_argoflow_addon ? 1 : 0
  name       = "argo-cd"
  chart      = "../argo-cd/"
  timeout    = 600
  namespace  = "atmosly"
  values     = ["${file("./argocd.yaml")}"]

}

data "kubernetes_secret" "argocd-secret" {
  depends_on = [helm_release.argocd_deploy]
  count      = var.enable_argoflow_addon ? 1 : 0
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "atmosly"
  }
}

resource "helm_release" "argo_workflow" {
  depends_on = [kubernetes_namespace.atmosly]
  count      = var.enable_argoflow_addon ? 1 : 0
  name       = "argo-workflows"
  chart      = "argo-workflows"
  timeout    = 600
  version    = "0.29.2"
  namespace  = "atmosly"
  repository = "https://argoproj.github.io/argo-helm"
  values = [templatefile("./argo-workflow.yaml", {
    ingress_host = var.argoworkflow_host
    }
    )
  ]
}


resource "helm_release" "argo_project" {
  depends_on = [helm_release.argocd_deploy, module.eks_addons]
  count      = var.enable_argoflow_addon ? 1 : 0
  name       = "argo-project"
  chart      = "../argo-projects"
  namespace  = "atmosly"
}

resource "kubernetes_storage_class" "ebs" {
  metadata {
    name = "ebs"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    encrypted = "true"
    kmskeyId  = var.kms_key_arn
    type      = "gp3"
  }

  reclaim_policy         = "Delete"
  allow_volume_expansion = true

}

resource "kubernetes_ingress_v1" "temporary" {
  count      = var.enable_aws_load_balancer_controller ? 1 : 0
  depends_on = [module.eks_addons]
  metadata {
    name      = "temporary-ingress"
    namespace = "atmosly"
    labels = {
      app = "temporary"
    }
    annotations = {
      "alb.ingress.kubernetes.io/group.name"           = "app-services"
      "alb.ingress.kubernetes.io/healthcheck-path"     = "/"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"          = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = "my-service"
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = "my-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

  }
}

resource "kubernetes_service" "my-service" {
  count      = var.enable_aws_load_balancer_controller ? 1 : 0
  depends_on = [kubernetes_namespace.atmosly]
  metadata {
    name      = "my-service"
    namespace = "atmosly"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}

data "kubernetes_ingress_v1" "example" {
  depends_on = [kubernetes_ingress_v1.temporary, time_sleep.wait_60_seconds]
  count      = var.enable_aws_load_balancer_controller ? 1 : 0
  metadata {
    name      = "temporary-ingress"
    namespace = "atmosly"
  }
}


resource "time_sleep" "wait_60_seconds" {
  depends_on = [kubernetes_ingress_v1.temporary]

  create_duration = "120s"
}

resource "kubernetes_service_account_v1" "argoworkflows-service-account" {
  count = var.enable_argoflow_addon ? 1 : 0
  metadata {
    name = "argo-workflow"
  }
}