resource "kubernetes_deployment" "pihole" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 2

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
      port        = 80
      target_port = 80
    }
  }
}

#####################################################################################################################

resource "kubernetes_ingress_v1" "pihole_ingress" {
  metadata {
    name = "pihole-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"           = "true"
      "nginx.ingress.kubernetes.io/configuration-snippet"  = "if ($uri = /) {return 302 /admin;}"
      "nginx.ingress.kubernetes.io/use-regex"              = "true"
      "nginx.ingress.kubernetes.io/affinity"               = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name"    = "INGRESSCOOKIE"
      "nginx.ingress.kubernetes.io/session-cookie-path"    = "/"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "3600"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["${var.app_name}.${var.local_domain}"]
      secret_name = var.local_tls_secret_name
    }

    rule {
      host = "${var.app_name}.${var.local_domain}"
      http {
        path {
          path      = "/(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = "pihole-http-service"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      http {
        path {
          path      = "/(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = "pihole-http-service"

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
