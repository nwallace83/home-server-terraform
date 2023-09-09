resource "kubernetes_service" "delugevpn" {
  metadata {
    name = "delugevpn-service"
  }

  spec {
    selector = {
      app = "delugevpn"
    }

    port {
      port        = 8112
      target_port = 8112
    }
  }
}
