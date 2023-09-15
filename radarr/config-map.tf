resource "kubernetes_config_map" "radarr_env" {
  metadata {
    name      = "${var.app_name}-env"
    namespace = var.namespace
  }

  data = {
    "PUID" = var.local_uid
    "PGID" = var.local_gid
    "TZ"   = var.timezone
  }
}
