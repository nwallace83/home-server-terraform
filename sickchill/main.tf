resource "kubernetes_deployment" "sickchill" {
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
          image             = "linuxserver/sickchill:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 8081
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.sickchill_env_config_map.metadata.0.name
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

#####################################################################################################################

resource "kubernetes_config_map" "sickchill_env_config_map" {
  metadata {
    name = "${var.app_name}-env-config-map"
  }

  data = {
    "PUID" = var.local_uid
    "PGID" = var.local_gid
    "TZ"   = var.timezone
  }
}

#####################################################################################################################

resource "kubernetes_service" "sickchill" {
  metadata {
    name = "${var.app_name}-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 8081
    }
  }
}

#####################################################################################################################

resource "kubernetes_ingress_v1" "sickchill_ingress" {
  metadata {
    name = "${var.app_name}-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts = [ "${var.app_name}.${var.local_domain}" ]
      secret_name = var.local_tls_secret_name
    }

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
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
