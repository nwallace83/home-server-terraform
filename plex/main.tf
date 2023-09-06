resource "kubernetes_deployment" "plex" {
  metadata {
    name = "plex"
    labels = {
      app = "plex"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "plex"
      }
    }

    template {
      metadata {
        labels = {
          app = "plex"
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
          name  = "plex"
          image = "plexinc/pms-docker:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 32400
            }
          }

          env {
            name  = "ADVERTISE_IP"
            value = "http://${var.local_ip}:32400/"
          }

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
            container_port = 32400
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "plex" {
  metadata {
    name = "plex-service"
  }

  spec {
    selector = {
      app = "plex"
    }

    port {
      port        = 32400
      target_port = 32400
    }
  }
}
