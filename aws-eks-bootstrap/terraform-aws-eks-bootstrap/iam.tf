resource "kubernetes_service_account_v1" "atmosly-service-account" {
  metadata {
    name = "atmosly-service-account"
  }
}

resource "kubernetes_secret_v1" "atmosly-service-account-secret" {
  metadata {
    name = "atmosly-service-account-secret"
    annotations = {
      "kubernetes.io/service-account.name" = "atmosly-service-account"
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "atmosly-clusterrole" {
  metadata {
    name = "atmosly-clusterrole"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "postman-crb" {
  depends_on = [kubernetes_cluster_role.atmosly-clusterrole]
  metadata {
    name = "a"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "atmosly-clusterrole"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "atmosly-service-account"
    namespace = "default"
  }
}

data "kubernetes_secret_v1" "atmosly-service-account-secret-data" {
  depends_on = [kubernetes_secret_v1.atmosly-service-account-secret, time_sleep.wait_60_seconds]
  metadata {
    name = "atmosly-service-account-secret"
  }
}
