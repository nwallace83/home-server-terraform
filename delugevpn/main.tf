resource "kubernetes_deployment" "delugevpn" {
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
          image             = "binhex/arch-delugevpn:latest"
          image_pull_policy = "Always"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.delugevpn_env_config_map.metadata.0.name
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
            container_port = 8112
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "delugevpn_env_config_map" {
  metadata {
    name = "delugevpn-env-config-map"
  }

  data = {
    "VPN_ENABLED"                  = "yes"
    "VPN_PROV"                     = "pia"
    "VPN_CLIENT"                   = "openvpn"
    "VPN_USER"                     = var.delugevpn_vpn_user
    "VPN_PASS"                     = var.delugevpn_vpn_password
    "ENABLE_PRIVOXY"               = "no"
    "STRICT_PORT_FORWARD"          = "yes"
    "LAN_NETWORK"                  = "192.168.0.0/24"
    "NAME_SERVERS"                 = "84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1"
    "DEBUG"                        = "false"
    "DELUGE_DAEMON_LOG_LEVEL"      = "info"
    "DELUGE_WEB_LOG_LEVEL"         = "info"
    "DELUGE_ENABLE_WEBUI_PASSWORD" = "yes"
    "UMASK"                        = "000"
    "PUID"                         = var.local_uid
    "PGID"                         = var.local_gid
    "TZ"                           = var.timezone
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
      port        = 80
      target_port = 8112
    }
  }
}

#####################################################################################################################

resource "kubernetes_ingress_v1" "delugevpn_ingress" {
  metadata {
    name = "${var.app_name}-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
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
