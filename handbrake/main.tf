resource "kubernetes_deployment" "handbrake" {
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
          name  = var.app_name
          image = "jlesage/handbrake:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 5800
            }
          }

          env {
            name  = "TZ"
            value = var.timezone
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

#####################################################################################################################

resource "kubernetes_service" "handbrake" {
  metadata {
    name = "${var.app_name}-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 8081
      target_port = 5800
    }
  }
}

#####################################################################################################################

resource "kubernetes_ingress_v1" "handbrake_ingress" {
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
                number = 8081
              }
            }
          }
        }
      }
    }
  }
}

