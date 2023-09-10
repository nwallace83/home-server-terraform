resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "nginx-ingress-tcp-microk8s-conf"
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
    name      = "nginx-ingress-udp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53" = "${var.namespace}/pihole-dns-service:53"
  }
}
