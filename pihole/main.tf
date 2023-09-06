resource "kubernetes_deployment" "pihole" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 2

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
          image             = "pihole/pihole:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/admin"
              port = 80
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.pihole_env_config_map.metadata.0.name
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
            container_port = 80
          }

          port {
            container_port = 53
            protocol       = "TCP"
          }

          port {
            container_port = 53
            protocol       = "UDP"
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "pihole_env_config_map" {
  metadata {
    name = "pihole-env-config-map"
  }

  data = {
    "TZ"                 = var.timezone
    "PIHOLE_UID"         = var.local_uid
    "PIHOLE_GID"         = var.local_gid
    "WEBPASSWORD"        = var.password
    "DNSMASQ_LISTENING"  = "all"
    "PIHOLE_DNS_"        = var.pihole_dns_origins
    "FTLCONF_LOCAL_IPV4" = var.local_ip
    "IPv6"               = "false"
    "FTLCONF_MAXDBDAYS"  = "7"
    "FTLCONF_GRAVITYDB"  = "/etc/pihole/gravity.db"
    "FTLCONF_DBFILE"     = "/etc/pihole/pihole-FTL.db"
  }
}

#####################################################################################################################

resource "kubernetes_service" "pihole_dns" {
  metadata {
    name = "pihole-dns-service"
  }

  spec {
    selector = {
      app = "pihole"
    }

    type = "ClusterIP"

    port {
      name        = "dns-tcp"
      port        = 53
      target_port = 53
      protocol    = "TCP"
    }

    port {
      name        = "dns-udp"
      port        = 53
      target_port = 53
      protocol    = "UDP"
    }

  }
}

#####################################################################################################################

resource "kubernetes_service" "pihole_http" {

  metadata {
    name = "pihole-http-service"
  }

  spec {
    selector = {
      app = "pihole"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}

#####################################################################################################################

output "pihole_http_service_port" {
  value = kubernetes_service.pihole_http.spec.0.port.0.port
}
