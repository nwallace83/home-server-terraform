resource "kubernetes_config_map" "delugevpn_env_config_map" {
  metadata {
    name      = "delugevpn-env-config-map"
    namespace = var.namespace
  }

  data = {
    "VPN_ENABLED"                  = "yes"
    "VPN_PROV"                     = "pia"
    "VPN_CLIENT"                   = "openvpn"
    "VPN_USER"                     = var.delugevpn_vpn_user
    "VPN_PASS"                     = var.delugevpn_vpn_password
    "ENABLE_PRIVOXY"               = "no"
    "STRICT_PORT_FORWARD"          = "yes"
    "LAN_NETWORK"                  = "192.168.0.0/24"
    "NAME_SERVERS"                 = "84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1"
    "DEBUG"                        = "false"
    "DELUGE_DAEMON_LOG_LEVEL"      = "info"
    "DELUGE_WEB_LOG_LEVEL"         = "info"
    "DELUGE_ENABLE_WEBUI_PASSWORD" = "yes"
    "UMASK"                        = "000"
    "PUID"                         = var.local_uid
    "PGID"                         = var.local_gid
    "TZ"                           = var.timezone
  }
}
