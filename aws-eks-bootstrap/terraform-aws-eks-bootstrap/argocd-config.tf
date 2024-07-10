resource "kubernetes_config_map_v1_data" "argo_cd_notifications_cm" {
  depends_on = [helm_release.argocd_deploy]
  count      = var.enable_argoflow_addon ? 1 : 0
  metadata {
    name      = "argocd-notifications-cm"
    namespace = "atmosly"
  }
  force = true

  data = {
    "context" = <<-EOT
      argocdUrl: localhost:8080
    EOT

    "service.webhook.atmosly" = <<-EOT
      url: ${var.backend_url}
      headers:
        - name: Content-Type
          value: application/json
        - name: Authorization
          value: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc5Mjg3OTcyLCJpYXQiOjE2NzkyODcwNzIsImp0aSI6IjA5ZTNiNzQxOWYxMzQyYjE4Zjc4OTQzNTE1NzRlNzc2IiwidXNlcl9pZCI6NH0.rIhn40xFc6NgCgid724cZ2orPXMRgo2Z4NdFOrGsdpE
    EOT

    "trigger.on-github-sync-status-unknown" = <<-EOT
      - when: app.status.sync.status == 'Unknown'
        send: [github-commit-status]
      - when: app.status.operationState.phase in ['Succeeded']
        send: [github-commit-status]
      - when: app.status.operationState.phase in ['Running']
        send: [github-commit-status]
      - when: app.status.operationState.phase in ['Error', 'Failed']
        send: [github-commit-status]
    EOT

    "trigger.on-github-sync-status-success" = <<-EOT
      - when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'
        send: [github-commit-status]
    EOT

    "trigger.on-database-status-unknown" = <<-EOT
      - when: app.status.sync.status == 'Unknown'
        send: [database-chart-status]
      - when: app.status.operationState.phase in ['Succeeded']
        send: [database-chart-status]
      - when: app.status.operationState.phase in ['Running']
        send: [database-chart-status]
      - when: app.status.operationState.phase in ['Error', 'Failed']
        send: [database-chart-status]
    EOT

    "trigger.on-database-status-success" = <<-EOT
      - when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'
        send: [database-chart-status]
    EOT

    "trigger.on-helm-sync-status-unknown" = <<-EOT
      - when: app.status.sync.status == 'Unknown'
        send: [helm-chart-status]
      - when: app.status.operationState.phase in ['Succeeded']
        send: [helm-chart-status]
      - when: app.status.operationState.phase in ['Running']
        send: [helm-chart-status]
      - when: app.status.operationState.phase in ['Error', 'Failed']
        send: [helm-chart-status]
    EOT

    "trigger.on-helm-sync-status-success" = <<-EOT
      - when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'
        send: [helm-chart-status]
    EOT

    "template.github-commit-status" = <<-EOT
      webhook:
        atmosly:
          method: POST
          path: /api/project_env/argocd/app/health/application/{{.app.metadata.labels.build_number}}/
          body: |
            {
              "app_name": "{{.app.metadata.name}}",
              "health_status": "{{.app.status.health.status}}"
            }
    EOT

    "template.helm-chart-status" = <<-EOT
      webhook:
        atmosly:
          method: POST
          path: /api/marketplace/argocd/app/health/{{.app.metadata.labels.build_number}}/
          body: |
            {
              "app_name": "{{.app.metadata.name}}",
              "health_status": "{{.app.status.health.status}}"
            }
    EOT

    "template.database-chart-status" = <<-EOT
      webhook:
        atmosly:
          method: POST
          path: /api/project_env/argocd/app/health/data_source/{{.app.metadata.labels.build_number}}/
          body: |
            {
              "app_name": "{{.app.metadata.name}}",
              "health_status": "{{.app.status.health.status}}"
            }
    EOT

  }
}