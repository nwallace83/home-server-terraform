resource "kubernetes_deployment" "sickchill" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

    revision_history_limit = 0
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        dynamic "volume" {
          for_each = var.volumes
          content {
            name = volume.value.name
            host_path {
              path = volume.value.host_path
              type = volume.value.type
            }
          }
        }

        container {
          name              = var.app_name
          image             = "linuxserver/sickchill:latest"
          image_pull_policy = "Always"

          readiness_probe {
            initial_delay_seconds = 60
            http_get {
              path = "/"
              port = 8081
            }
          }

          liveness_probe {
            initial_delay_seconds = 60
            http_get {
              path = "/"
              port = 8081
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.sickchill_env.metadata.0.name
            }
          }

          dynamic "volume_mount" {
            for_each = var.volumes
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.container_path
              read_only  = volume_mount.value.read_only
            }
          }

          port {
            container_port = 8081
          }
        }
      }
    }
  }
}
