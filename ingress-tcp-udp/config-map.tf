resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "tcp-services"
    namespace = var.ingress_namespace
  }

  data = {
    "53"   = "${var.namespace}/pihole-dns-service:53"
    "8112" = "${var.namespace}/delugevpn-service:8112"
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "udp_services" {
  metadata {
    name      = "udp-services"
    namespace = var.ingress_namespace
  }

  data = {
    "53" = "${var.namespace}/pihole-dns-service:53"
  }
}
