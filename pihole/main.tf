resource "kubernetes_deployment" "pihole" {
  metadata {
    name = "pihole"
    labels = {
      app = "pihole"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "pihole"
      }
    }

    template {
      metadata {
        labels = {
          app = "pihole"
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
          name  = "pihole"
          image = "pihole/pihole:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/admin"
              port = 80
            }
          }

          env {
            name  = "TZ"
            value = "America/Denver"
          }

          env {
            name = "PIHOLE_UID"
            value = var.local_uid
          }

          env {
            name = "PIHOLE_GID"
            value = var.local_gid
          }

          env {
            name  = "WEBPASSWORD"
            value = var.password
          }

          env {
            name  = "DNSMASQ_LISTENING"
            value = "all"
          }

          env {
            name  = "PIHOLE_DNS_"
            value = var.pihole_dns_origins
          }

          env {
            name  = "FTLCONF_LOCAL_IPV4"
            value = var.local_ip
          }

          env {
            name  = "IPv6"
            value = "false"
          }

          env {
            name  = "FTLCONF_MAXDBDAYS"
            value = "7"
          }

          env {
            name  = "FTLCONF_GRAVITYDB"
            #value = "/opt/pihole/gravity.db"
            value = "/etc/pihole/gravity.db"
          }

          env {
            name  = "FTLCONF_DBFILE"
            #value = "/opt/pihole/pihole-FTL.db"
            value = "/etc/pihole/pihole-FTL.db"
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
