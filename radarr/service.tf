resource "kubernetes_service" "radarr" {
  metadata {
    name      = "${var.app_name}"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      name        = "http"
      port        = 80
      target_port = 7878
    }
  }
}
