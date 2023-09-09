resource "kubernetes_service" "radarr-http" {
  metadata {
    name = "${var.app_name}-http-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 7878
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "radarr-tcp" {
  metadata {
    name = "${var.app_name}-tcp-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 8082
      target_port = 7878
    }
  }
}
