resource "kubernetes_service" "sickchill-tcp" {
  metadata {
    name = "${var.app_name}-tcp-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 8081
      target_port = 8081
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "sickchill-http" {
  metadata {
    name = "${var.app_name}-http-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 8081
    }
  }
}
