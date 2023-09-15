resource "kubernetes_deployment" "delugevpn" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    revision_history_limit = 0
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

        volume {
          name = "ca-crt"
          config_map {
            name = kubernetes_config_map.delugevpn_openvpn_volume.metadata.0.name
            items {
              key  = "ca.rsa.2048.crt"
              path = "ca.rsa.2048.crt"
            }
          }
        }

        volume {
          name = "crl-pem"
          config_map {
            name = kubernetes_config_map.delugevpn_openvpn_volume.metadata.0.name
            items {
              key  = "crl.rsa.2048.pem"
              path = "crl.rsa.2048.pem"
            }
          }
        }

        volume {
          name = "mexico-ovpn"
          config_map {
            name = kubernetes_config_map.delugevpn_openvpn_volume.metadata.0.name
            items {
              key  = "mexico.ovpn"
              path = "mexico.ovpn"
            }
          }
        }

        container {
          name              = var.app_name
          image             = "binhex/arch-delugevpn:latest"
          image_pull_policy = "Always"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          readiness_probe {
            initial_delay_seconds = 60
            failure_threshold = 30
            period_seconds = 10
            timeout_seconds = 5
            http_get {
              path = "/"
              port = 8112
            }
          }

          liveness_probe {
            initial_delay_seconds = 60
            failure_threshold = 30
            period_seconds = 10
            timeout_seconds = 5
            http_get {
              path = "/"
              port = 8112
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.delugevpn_env.metadata.0.name
            }
          }

          volume_mount {
            name       = "ca-crt"
            mount_path = "/config/openvpn/ca.rsa.2048.crt"
            sub_path   = "ca.rsa.2048.crt"
          }

          volume_mount {
            name       = "crl-pem"
            mount_path = "/config/openvpn/crl.rsa.2048.pem"
            sub_path   = "crl.rsa.2048.pem"
          }

          volume_mount {
            name       = "mexico-ovpn"
            mount_path = "/config/openvpn/mexico.ovpn"
            sub_path   = "mexico.ovpn"
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
            container_port = 8112
          }
        }
      }
    }
  }
}
