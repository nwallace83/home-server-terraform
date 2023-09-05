resource "kubernetes_deployment" "delugevpn" {
  metadata {
    name = "delugevpn"
    labels = {
      app = "delugevpn"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "delugevpn"
      }
    }

    template {
      metadata {
        labels = {
          app = "delugevpn"
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
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          name  = "delugevpn"
          image = "binhex/arch-delugevpn:latest"

          env {
            name  = "VPN_ENABLED"
            value = "yes"
          }

          env {
            name  = "VPN_PROV"
            value = "pia"
          }

          env {
            name  = "VPN_CLIENT"
            value = "openvpn"
          }

          env {
            name  = "VPN_USER"
            value = var.delugevpn_vpn_user
          }

          env {
            name  = "VPN_PASS"
            value = var.delugevpn_vpn_password
          }

          env {
            name  = "ENABLE_PRIVOXY"
            value = "no"
          }

          env {
            name  = "STRICT_PORT_FORWARD"
            value = "yes"
          }

          env {
            name  = "LAN_NETWORK"
            value = "192.168.0.0/24"
          }

          env {
            name  = "NAME_SERVERS"
            value = "84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1"
          }

          env {
            name  = "DEBUG"
            value = "false"
          }

          env {
            name  = "DELUGE_DAEMON_LOG_LEVEL"
            value = "info"
          }

          env {
            name  = "DELUGE_WEB_LOG_LEVEL"
            value = "info"
          }

          env {
            name  = "DELUGE_ENABLE_WEBUI_PASSWORD"
            value = "yes"
          }

          env {
            name  = "UMASK"
            value = "000"
          }

          env {
            name  = "PUID"
            value = var.local_uid
          }

          env {
            name  = "PGID"
            value = var.local_gid
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
            container_port = 8112
          }

          # port {
          #   container_port = 58846
          # }

          # port {
          #   container_port = 58946
          # }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "delugevpn" {
  metadata {
    name = "delugevpn-service"
  }

  spec {
    selector = {
      app = "delugevpn"
    }

    port {
      port        = 8112
      target_port = 8112
    }
  }
}
