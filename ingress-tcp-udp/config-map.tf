resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "tcp-services"
    namespace = var.ingress_namespace
  }

  data = {
    "53"   = "${var.namespace}/pihole-dns:53"
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "udp_services" {
  metadata {
    name      = "udp-services"
    namespace = var.ingress_namespace
  }

  data = {
    "53" = "${var.namespace}/pihole-dns:53"
  }
}
