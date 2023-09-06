resource "kubernetes_deployment" "radarr" {
  metadata {
    name = var.app_name
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
          image             = "linuxserver/radarr:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 7878
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.radarr_env_config_map.metadata.0.name
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
            container_port = 7878
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "radarr_env_config_map" {
  metadata {
    name = "${var.app_name}-env-config-map"
  }

  data = {
    "PUID" = var.local_uid
    "PGID" = var.local_gid
    "TZ"   = "America/Denver"
  }
}

#####################################################################################################################

resource "kubernetes_service" "radarr" {
  metadata {
    name = "${var.app_name}-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 8082
      target_port = 7878
    }
  }
}

#####################################################################################################################

output "radarr_service_port" {
  value = kubernetes_service.radarr.spec.0.port.0.port
}
