resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name = "pihole-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/affinity"               = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name"    = "route"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "3600"
    }
  }

  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = "pihole-http-service"
        port {
          number = var.pihole_http_service_port
        }
      }
    }

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "pihole-http-service"

              port {
                number = var.pihole_http_service_port
              }
            }
          }
        }
      }
    }
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "nginx-ingress-tcp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53"    = "default/pihole-dns-service:53"
    "8112"  = "default/delugevpn-service:${var.delugevpn_service_port}"
    "8081"  = "default/sickchill-service:${var.sickchill_service_port}"
    "8082"  = "default/radarr-service:${var.radarr_service_port}"
    "8083"  = "default/prowlarr-service:${var.prowlarr_service_port}"
    "8084"  = "default/handbrake-service:${var.handbrake_service_port}"
    "32400" = "default/plex-service:${var.plex_service_port}"
  }
}

resource "kubernetes_config_map" "udp_services" {
  metadata {
    name      = "nginx-ingress-udp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53" = "default/pihole-dns-service:53"
  }
}
