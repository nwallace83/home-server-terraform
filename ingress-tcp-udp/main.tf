
resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "nginx-ingress-tcp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53"   = "default/pihole-dns-service:53"
    "8112" = "default/delugevpn-service:8112"
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

#####################################################################################################################

resource "kubernetes_secret" "local_tls_secret" {
  metadata {
    name = "local-tls-secret"
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64decode(var.tls_certificate)
    "tls.key" = base64decode(var.tls_key)
  }
}

#####################################################################################################################

output "local_tls_secret_name" {
  value = kubernetes_secret.local_tls_secret.metadata.0.name
}
