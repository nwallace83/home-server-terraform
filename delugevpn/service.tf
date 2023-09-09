resource "kubernetes_service" "delugevpn" {
  metadata {
    name      = "delugevpn-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "delugevpn"
    }

    port {
      name        = "http"
      port        = 8112
      target_port = 8112
    }
  }
}
