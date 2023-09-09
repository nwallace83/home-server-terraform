
resource "kubernetes_config_map" "sickchill_env_config_map" {
  metadata {
    name = "${var.app_name}-env-config-map"
  }

  data = {
    "PUID" = var.local_uid
    "PGID" = var.local_gid
    "TZ"   = var.timezone
  }
}

