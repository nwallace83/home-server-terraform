resource "kubernetes_config_map" "plex_env_config_map" {
  metadata {
    name      = "${var.app_name}-env-config-map"
    namespace = var.namespace
  }

  data = {
    "ADVERTISE_IP" = "http://${var.local_ip}:32400,http://${var.app_name}.${var.local_domain}:32400,http://${var.app_name}.${var.local_domain}"
    "TZ"           = var.timezone
    "VERSION"      = "docker"
    "PLEX_CLAIM"   = "claim-XVsJRWJSQMNyu3RvBWkJ"
  }
}
