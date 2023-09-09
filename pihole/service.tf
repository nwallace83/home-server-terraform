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

resource "kubernetes_service" "pihole" {

  metadata {
    name = "pihole-service"
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
