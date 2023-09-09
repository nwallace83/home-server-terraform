resource "kubernetes_deployment" "pihole" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas               = 2
    revision_history_limit = 0

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 2
        max_unavailable = 0
      }
    }

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        volume {
          name = "custom-list"
          config_map {
            name = kubernetes_config_map.pihole_custom_list_map.metadata.0.name
            items {
              key  = "custom.list"
              path = "custom.list"
            }
          }
        }

        volume {
          name = "etc-pihole"
          empty_dir {
            medium     = "Memory"
            size_limit = "1Gi"
          }
        }

        volume {
          name = "etc-dnsmasq-d"
          empty_dir {
            medium     = "Memory"
            size_limit = "512Mi"
          }
        }

        container {
          name              = var.app_name
          image             = "pihole/pihole:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/admin"
              port = 80
            }
          }

          volume_mount {
            name       = "etc-pihole"
            mount_path = "/etc/pihole"
          }

          volume_mount {
            name       = "etc-dnsmasq-d"
            mount_path = "/etc/dnsmasq.d"
          }

          volume_mount {
            name       = "custom-list"
            mount_path = "/etc/pihole/custom.list"
            sub_path   = "custom.list"
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.pihole_env_config_map.metadata.0.name

            }
          }

          lifecycle {
            post_start {
              exec {
                command = [
                  "sh", "-c", "sleep 5 && sqlite3 /etc/pihole/gravity.db \"INSERT INTO adlist (address, enabled, comment) VALUES ('https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt', 1, '');\" && sqlite3 /etc/pihole/gravity.db \"INSERT INTO adlist (address, enabled, comment) VALUES ('https://dbl.oisd.nl', 1, '');\" && pihole updateGravity"
                ]
              }
            }
          }

          port {
            container_port = 80
          }

          port {
            container_port = 53
            protocol       = "TCP"
          }

          port {
            container_port = 53
            protocol       = "UDP"
          }
        }
      }
    }
  }
}
