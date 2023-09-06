resource "kubernetes_deployment" "handbrake" {
  metadata {
    name = "handbrake"
    labels = {
      app = "handbrake"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "handbrake"
      }
    }

    template {
      metadata {
        labels = {
          app = "handbrake"
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
          name  = "handbrake"
          image = "jlesage/handbrake:latest"
          image_pull_policy = "Always"

          env {
            name  = "TZ"
            value = "America/Denver"
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
            container_port = 5800
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "handbrake" {
  metadata {
    name = "handbrake-service"
  }

  spec {
    selector = {
      app = "handbrake"
    }

    port {
      port        = 8084
      target_port = 5800
    }
  }
}
