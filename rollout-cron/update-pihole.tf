resource "kubernetes_cron_job_v1" "update_pihole" {
  metadata {
    name      = "update-pihole"
    namespace = var.namespace
  }

  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    successful_jobs_history_limit = 1
    schedule                      = "1 3 1 * *"
    job_template {
      metadata {}
      spec {
        template {
          metadata {}
          spec {
            service_account_name = var.service_account

            container {
              name  = "update-app-pihole"
              image = "bitnami/kubectl"

              command = ["kubectl", "rollout", "restart", "deployment", "pihole"]
            }
          }
        }
      }
    }
  }
}

