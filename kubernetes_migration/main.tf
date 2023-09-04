resource "kubernetes_deployment" "sickchill" {
  metadata {
    name = "sickchill"
    labels = {
      app = "sickchill"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sickchill"
      }
    }

    template {
      metadata {
        labels = {
          app = "sickchill"
        }
      }

      spec {
        volume {
          name = "test"
          host_path {
            path = "/tmp/docker/sickchill/config"
          }
          # persistent_volume_claim {
          #   claim_name = kubernetes_persistent_volume_claim.sickchill-config-volume-claim.metadata.0.name
          # }
        }

        container {
          name  = "sickchill"
          image = "linuxserver/sickchill:latest"

          volume_mount {
            name = "test"
            mount_path = "/config"
          }

          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sickchill" {
  metadata {
    name = "sickchill-service"
  }

  spec {
    selector = {
      app = "sickchill"
    }

    port {
      port        = 8081
      target_port = 8081
    }

  }
}

# resource "kubernetes_persistent_volume_claim" "sickchill-config-volume-claim" {
#   metadata {
#     name = "sickchill-config-volume-claim"
#   }

#   spec {
#     access_modes = [ "ReadWriteOnce" ]
#     volume_name = kubernetes_deployment.sickchill.metadata.0.name
#     # storage_class_name = "hostpath"
  
#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#   }
# }

# resource "kubernetes_persistent_volume" "sickchill" {
#   metadata {
#     name = "sickchill-config-volume"
#   }

#   spec {
#     capacity = {
#       storage = "1Gi"
#     }

#     access_modes = ["ReadWriteOnce"]
#     persistent_volume_reclaim_policy = "Retain"
#     # storage_class_name = "hostpath"
#     persistent_volume_source {
#       local {
#         path = "/tmp"
#       }
#     }

#     node_affinity {
#       required {
#         node_selector_term {
#           match_expressions {
#             key = "kubernetes.io/hostname"
#             operator = "In"
#             values = ["docker-desktop"]
#           }
#         }
#       }
#     }
#   }
# }
