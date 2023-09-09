resource "kubernetes_service" "prowlarr-http" {
  metadata {
    name = "${var.app_name}-http-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 9696
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "prowlarr-tcp" {
  metadata {
    name = "${var.app_name}-tcp-service"
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 8083
      target_port = 9696
    }
  }
}