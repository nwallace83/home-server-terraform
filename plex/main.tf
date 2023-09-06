resource "kubernetes_deployment" "plex" {
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
          image             = "plexinc/pms-docker:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 32400
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.plex_env_config_map.metadata.0.name
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
            container_port = 32400
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "plex_env_config_map" {
  metadata {
    name = "${var.app_name}-env-config-map"
  }

  data = {
    "ADVERTISE_IP" = "http://${var.local_ip}:32400/"
    "TZ"           = var.timezone
  }
}

#####################################################################################################################

resource "kubernetes_ingress_v1" "plex_ingress" {
  metadata {
    name = "${var.app_name}-ingress"
  }

  spec {
    ingress_class_name = "nginx"
    
    rule {
      host = "${var.app_name}.${var.local_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.app_name}-service"

              port {
                number = 32400
              }
            }
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "plex" {
  metadata {
    name = "${var.app_name}-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 32400
      target_port = 32400
    }
  }
}
