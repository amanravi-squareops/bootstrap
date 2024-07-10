output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = local.environment
}

output "nginx_ingress_controller_dns_hostname" {
  description = "NGINX Ingress Controller DNS Hostname"
  value       = var.enable_ingress_nginx ? module.eks_addons.nginx_ingress_controller_dns_hostname : ""
}

output "ebs_encryption" {
  description = "Is AWS EBS encryption is enabled or not?"
  value       = "Encrypted by default"
}

output "efs_id" {
  value       = module.eks_addons.efs_id
  description = "EFS ID"
}

output "aws_load_balancer_controller_hostname" {
  value = var.enable_aws_load_balancer_controller ? data.kubernetes_ingress_v1.example[0].status.0.load_balancer.0.ingress.0.hostname : ""
}

output "BearerToken" {
  value = base64encode(nonsensitive(data.kubernetes_secret_v1.atmosly-service-account-secret-data.data.token))
}

output "k8s-dashboard-admin-token" {
  description = "k8s-dashboard admin token"
  value       = base64encode(var.kubernetes_dashboard_enabled ? module.eks_addons.k8s-dashboard-admin-token : "")
}

output "k8s-dashboard-read-only-token" {
  description = "k8s-dashboard read only  token"
  value       = base64encode(var.kubernetes_dashboard_enabled ? module.eks_addons.k8s-dashboard-read-only-token : "")
}

output "argoworkflow_host" {
  value = var.argoworkflow_host
}