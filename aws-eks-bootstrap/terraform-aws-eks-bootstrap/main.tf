locals {
  region      = var.region
  environment = var.environment
  name        = var.name
  additional_tags = {
    "provider" = "atmosly"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Subnet-group = "private"
  }
}


# module "eks_bootstrap" {
#   source                                        = "squareops/eks-bootstrap/aws"
#   version                                       = "3.1.1"
#   environment                                   = local.environment
#   name                                          = local.name
#   eks_cluster_name                              = var.cluster_name
#   single_az_sc_config                           = [{ name = "single-az-sc", zone = format("%s%s", var.region, "a") }]
#   kms_key_arn                                   = var.kms_key_arn
#   kms_policy_arn                                = var.kms_policy_arn
#   cert_manager_letsencrypt_email                = var.cert_manager_letsencrypt_email
#   vpc_id                                        = var.vpc_id
#   single_az_ebs_gp3_storage_class_enabled       = var.enable_single_az_ebs_gp3_storage_class  
#   amazon_eks_aws_ebs_csi_driver_enabled         = var.enable_amazon_eks_aws_ebs_csi_driver
#   amazon_eks_vpc_cni_enabled                    = var.enable_amazon_eks_vpc_cni
#   service_monitor_crd_enabled                   = var.create_service_monitor_crd
#   cluster_autoscaler_enabled                     = var.enable_cluster_autoscaler
#   cluster_propotional_autoscaler_enabled         = var.enable_cluster_propotional_autoscaler
#   reloader_enabled                              = var.enable_reloader
#   metrics_server_enabled                         = var.enable_metrics_server
#   ingress_nginx_enabled                         = var.enable_ingress_nginx
#   cert_manager_enabled                          = var.cert_manager_enabled
#   cert_manager_install_letsencrypt_http_issuers = var.cert_manager_install_letsencrypt_http_issuers
#   external_secrets_enabled                       = var.enable_external_secrets
#   keda_enabled                                   = var.enable_keda
#   efs_storage_class_enabled                     = var.create_efs_storage_class
#   private_subnet_ids                            = data.aws_subnets.private.ids
#   istio_enabled                                 = var.enable_istio
#   karpenter_enabled                             = var.enable_karpenter
#   aws_node_termination_handler_enabled           = var.enable_aws_node_termination_handler
#   worker_iam_role_name                          = var.worker_iam_role_name
#   worker_iam_role_arn                           = data.aws_iam_role.worker_role.arn
#   karpenter_provisioner_enabled                 = var.enable_karpenter
#   kubeclarity_enabled                           = var.kubeclarity_enabled
#   kubeclarity_hostname                          = var.kubeclarity_hostname
#   enable_aws_load_balancer_controller           = var.enable_aws_load_balancer_controller
#   karpenter_provisioner_config = {
#     private_subnet_name    = format("%s-%s-%s", local.environment, local.name, "private-subnet")
#     instance_capacity_type = ["spot"]
#     excluded_instance_type = ["nano", "micro", "small"]
#     instance_hypervisor    = ["nitro"]
#   }
#   velero_config = {
#     namespaces                      = "" ## If you want full cluster backup, leave it blank else provide namespace.
#     slack_notification_token        = "" 
#     slack_notification_channel_name = ""
#     retention_period_in_days        = 45
#     schedule_backup_cron_time       = ""
#     velero_backup_name              = ""
#     backup_bucket_name              = ""
#   }
# }

data "aws_iam_role" "worker_role" {
  name = var.worker_iam_role_name
}


module "eks_addons" {
  source = "../terraform-aws-eks-addons"
  # version                             = "1.1.6"
  name                                 = var.name
  vpc_id                               = var.vpc_id
  environment                          = var.vpc_id
  ipv6_enabled                         = var.ipv6_enabled
  kms_key_arn                          = var.kms_key_arn
  keda_enabled                         = var.enable_keda
  kms_policy_arn                       = var.kms_policy_arn
  eks_cluster_name                     = var.cluster_name
  reloader_enabled                     = var.enable_reloader
  kubernetes_dashboard_enabled         = var.kubernetes_dashboard_enabled
  k8s_dashboard_ingress_load_balancer  = var.k8s_dashboard_ingress_load_balancer
  alb_acm_certificate_arn              = var.alb_acm_certificate_arn
  k8s_dashboard_hostname               = var.k8s_dashboard_hostname
  karpenter_enabled                    = var.enable_karpenter
  private_subnet_ids                   = data.aws_subnets.private.ids
  single_az_sc_config                  = [{ name = "single-az-sc", zone = format("%s%s", var.region, "a") }]
  kubeclarity_enabled                  = var.kubeclarity_enabled
  kubeclarity_hostname                 = var.kubeclarity_hostname
  kubecost_enabled                     = var.kubecost_enabled
  kubecost_hostname                    = var.kubecost_hostname
  defectdojo_enabled                   = var.defectdojo_enabled
  defectdojo_hostname                  = var.defectdojo_hostname
  cert_manager_enabled                 = var.cert_manager_enabled
  worker_iam_role_name                 = var.worker_iam_role_name
  worker_iam_role_arn                  = data.aws_iam_role.worker_role.arn
  ingress_nginx_enabled                = var.enable_ingress_nginx
  metrics_server_enabled               = var.enable_metrics_server
  external_secrets_enabled             = var.enable_external_secrets
  amazon_eks_vpc_cni_enabled           = var.enable_amazon_eks_vpc_cni
  cluster_autoscaler_enabled           = var.enable_cluster_autoscaler
  service_monitor_crd_enabled          = var.create_service_monitor_crd
  aws_load_balancer_controller_enabled = var.enable_aws_load_balancer_controller
  istio_enabled                        = var.enable_istio
  istio_config = {
    ingress_gateway_enabled       = var.istio_ingress_gateway_enable
    egress_gateway_enabled        = var.istio_egress_gateway_enable
    envoy_access_logs_enabled     = var.istio_envoy_access_logs_enabled
    prometheus_monitoring_enabled = var.istio_monitoring_enabled
    istio_values_yaml             = ""
  }
  karpenter_provisioner_enabled = var.karpenter_provisioner_enabled
  karpenter_provisioner_config = {
    aws_availability_zones = var.aws_availability_zones
    private_subnet_name    = format("%s-%s-%s", local.environment, local.name, "private-subnet")
    instance_capacity_type = ["spot"]
    excluded_instance_type = ["nano", "micro", "small"]
    instance_hypervisor    = ["nitro"] ## Instance hypervisor is picked up only if IPv6 enable is chosen
  }
  cert_manager_letsencrypt_email                = var.cert_manager_letsencrypt_email
  internal_ingress_nginx_enabled                = var.enable_internal_ingress_nginx_enabled
  efs_storage_class_enabled                     = var.create_efs_storage_class
  aws_node_termination_handler_enabled          = var.enable_aws_node_termination_handler
  amazon_eks_aws_ebs_csi_driver_enabled         = var.enable_amazon_eks_aws_ebs_csi_driver
  cluster_propotional_autoscaler_enabled        = var.enable_cluster_propotional_autoscaler
  single_az_ebs_gp3_storage_class_enabled       = var.enable_single_az_ebs_gp3_storage_class
  cert_manager_install_letsencrypt_http_issuers = var.cert_manager_enabled
  velero_enabled                                = var.enable_velero
  velero_config = {
    namespaces                      = "" ## If you want full cluster backup, leave it blank else provide namespace.
    slack_notification_token        = ""
    slack_notification_channel_name = ""
    retention_period_in_days        = 45
    schedule_backup_cron_time       = "* 6 * * *"
    velero_backup_name              = "my-application-backup"
    backup_bucket_name              = var.velero_backup_bucket_name
  }
}