resource "kubernetes_service" "plex" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      name        = "http"
      port        = 80
      target_port = 32400
    }
  }
}

#####################################################################################################################

resource "kubernetes_service" "plex-tcp" {
  metadata {
    name      = "${var.app_name}-tcp-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "NodePort"
    port {
      node_port   = 32400
      port        = 32400
      target_port = 32400
    }
  }
}
