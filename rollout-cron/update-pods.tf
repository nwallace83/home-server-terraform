resource "kubernetes_cron_job_v1" "update_apps" {
  metadata {
    name      = "update-apps"
    namespace = var.namespace
  }

  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    successful_jobs_history_limit = 1
    schedule                      = "1 3 * * 0"
    job_template {
      metadata {}
      spec {
        template {
          metadata {}
          spec {
            service_account_name = var.service_account

            dynamic "container" {
              for_each = var.applications
              content {
                name  = "update-app-${container.value}"
                image = "bitnami/kubectl"

                command = ["kubectl", "rollout", "restart", "deployment", container.value]
              }
            }
          }
        }
      }
    }
  }
}

variable "applications" {
  type    = list(string)
  default = ["handbrake", "sickchill", "delugevpn", "plex", "prowlarr", "radarr"]
}
