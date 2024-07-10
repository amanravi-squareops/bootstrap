# Common Variables
variable "region" {
  type        = string
  description = "Region for the Cluster"
}

variable "environment" {
  type        = string
  description = "(optional) describe your variable"
}

variable "name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster in which to deploy"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN for the KMS key"
}

variable "kms_policy_arn" {
  type        = string
  description = "ARN for the KMS policy"
}

variable "cert_manager_letsencrypt_email" {
  type        = string
  description = "Email address for cert mananger cert issuer"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which cluster is present"
}

variable "enable_single_az_ebs_gp3_storage_class" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_amazon_eks_aws_ebs_csi_driver" {
  type        = bool
  default     = true
  description = "Set it to true to deploy EBS csi driver"
}

variable "enable_amazon_eks_vpc_cni" {
  type        = bool
  default     = true
  description = "Set it to true to deploy VPC CNI"
}

variable "create_service_monitor_crd" {
  type        = bool
  default     = true
  description = "Set it to true to create service monitor CRD"
}

variable "enable_cluster_autoscaler" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_cluster_propotional_autoscaler" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_reloader" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_metrics_server" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_ingress_nginx" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "cert_manager_enabled" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "cert_manager_install_letsencrypt_http_issuers" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_external_secrets" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_keda" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "create_efs_storage_class" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "enable_istio" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "enable_karpenter" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "enable_aws_node_termination_handler" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "worker_iam_role_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "enable_velero" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "slack_token" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "slack_channel_name" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "retention_period_in_days" {
  type        = number
  default     = 45
  description = "(optional) describe your variable"
}

variable "namespaces_to_backup" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "velero_backup_bucket_name" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "velero_backup_name" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "schedule_backup_cron_time" {
  type        = string
  default     = "* 6 * * *"
  description = "(optional) describe your variable"
}

variable "karpenter_provisioner_enabled" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}

variable "role_arn" {
  type        = string
  description = "Role ARN of the IAM role."
}

variable "external_id" {
  type        = string
  description = "External ID for the role"
}
variable "kubeclarity_hostname" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "kubeclarity_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "enable_aws_load_balancer_controller" {
  type        = bool
  description = "(optional) describe your variable"
}


variable "backend_url" {
  type    = string
  default = "https://backend.dev.atmosly.com"

}

variable "ipv6_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "kubecost_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "kubecost_hostname" {
  type    = string
  default = ""

}

variable "defectdojo_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "defectdojo_hostname" {
  type        = string
  default     = ""
  description = "(optional) describe your variable"
}

variable "istio_ingress_gateway_enable" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "istio_egress_gateway_enable" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "istio_envoy_access_logs_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "istio_monitoring_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "enable_internal_ingress_nginx_enabled" {
  type        = bool
  default     = false
  description = "(optional) describe your variable"
}

variable "kubernetes_dashboard_enabled" {
  description = "Determines whether k8s-dashboard is enabled or not"
  default     = false
  type        = bool
}

variable "k8s_dashboard_ingress_load_balancer" {
  description = "Determines which load balancer type should be used NLB or ALB"
  default     = "NLB"
  type        = string
}

variable "alb_acm_certificate_arn" {
  description = "Specify the ACM Certificate ARN to be used with ALB"
  default     = ""
  type        = string
}

variable "k8s_dashboard_hostname" {
  description = "Specify the hostname for the k8s dashboard."
  default     = ""
  type        = string
}

variable "enable_argoflow_addon" {
  description = "Specify whether to deploy argo workflow and argocd addon"
  type        = bool
  default     = true
}

variable "argoworkflow_host" {
  type        = string
  description = "Define the host for argo workflow server"
  default     = "argoworkflow.atmosly.in"
}

variable "aws_availability_zones" {
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b"]
  description = "(optional) describe your variable"
}