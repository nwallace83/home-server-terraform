resource "kubernetes_config_map" "pihole_env_config_map" {
  metadata {
    name = "pihole-env-config-map"
  }

  data = {
    "TZ"                 = var.timezone
    "PIHOLE_UID"         = var.local_uid
    "PIHOLE_GID"         = var.local_gid
    "WEBPASSWORD"        = var.password
    "DNSMASQ_LISTENING"  = "all"
    "PIHOLE_DNS_"        = var.pihole_dns_origins
    "FTLCONF_LOCAL_IPV4" = var.local_ip
    "IPv6"               = "false"
    "FTLCONF_MAXDBDAYS"  = "7"
  }
}

#####################################################################################################################

resource "kubernetes_config_map" "pihole_custom_list_map" {
  metadata {
    name = "pihole-custom-list-map"
  }

  data = {
    "custom.list" = base64decode(var.pihole_custom_list)
  }
}
