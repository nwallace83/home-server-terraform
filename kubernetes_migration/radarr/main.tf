resource "kubernetes_deployment" "radarr" {
  metadata {
    name = "radarr"
    labels = {
      app = "radarr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "radarr"
      }
    }

    template {
      metadata {
        labels = {
          app = "radarr"
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
          name  = "radarr"
          image = "linuxserver/radarr:latest"

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
            container_port = 7878
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "radarr" {
  metadata {
    name = "radarr-service"
  }

  spec {
    selector = {
      app = "radarr"
    }

    port {
      port        = 8082
      target_port = 7878
    }
  }
}
