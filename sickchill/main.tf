resource "kubernetes_deployment" "sickchill" {
  metadata {
    name = "sickchill"
    labels = {
      app = "sickchill"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sickchill"
      }
    }

    template {
      metadata {
        labels = {
          app = "sickchill"
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
          name  = "sickchill"
          image = "linuxserver/sickchill:latest"
          image_pull_policy = "Always"

          env {
            name  = "TZ"
            value = "America/Denver"
          }

          env {
            name  = "PUID"
            value = var.local_uid
          }

          env {
            name  = "PGID"
            value = var.local_gid
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

resource "kubernetes_service" "sickchill" {
  metadata {
    name = "sickchill-service"
  }

  spec {
    selector = {
      app = "sickchill"
    }

    port {
      port        = 8081
      target_port = 8081
    }
  }
}
