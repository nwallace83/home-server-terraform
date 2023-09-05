resource "kubernetes_deployment" "prowlarr" {
  metadata {
    name = "prowlarr"
    labels = {
      app = "prowlarr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prowlarr"
      }
    }

    template {
      metadata {
        labels = {
          app = "prowlarr"
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
          name  = "prowlarr"
          image = "linuxserver/prowlarr:latest"

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
            container_port = 9696
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "prowlarr" {
  metadata {
    name = "prowlarr-service"
  }

  spec {
    selector = {
      app = "prowlarr"
    }

    port {
      port        = 8083
      target_port = 9696
    }
  }
}
