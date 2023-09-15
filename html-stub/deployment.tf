resource "kubernetes_deployment" "htmlstub" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

    revision_history_limit = 0
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        volume {
          name = "index-html"
          config_map {
            name = kubernetes_config_map.html_stub_volume.metadata.0.name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }

        container {
          name              = var.app_name
          image             = "nginx:latest"
          image_pull_policy = "Always"

          readiness_probe {
            initial_delay_seconds = 60
            http_get {
              path = "/"
              port = 80
            }
          }

          liveness_probe {
            initial_delay_seconds = 60
            http_get {
              path = "/"
              port = 80
            }
          }

          volume_mount {
            name       = "index-html"
            mount_path = "/usr/share/nginx/html/index.html"
            sub_path   = "index.html"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

