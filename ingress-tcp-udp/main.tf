
resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "nginx-ingress-tcp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53"    = "default/pihole-dns-service:53"
    "32400" = "default/plex-service:32400"
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
