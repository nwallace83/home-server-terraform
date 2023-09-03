resource "docker_image" "delugevpn" {
  name         = "binhex/arch-delugevpn:latest"
  keep_locally = true
}

resource "docker_container" "delugevpn" {
  image    = docker_image.delugevpn.image_id
  name     = "delugevpn"
  restart  = "unless-stopped"
  hostname = "delugevpn"
  dns      = [var.dns_server, "1.1.1.1"]
  env = [
    "TZ=American/Denver",
    "VPN_ENABLED=yes",
    "VPN_PROV=pia",
    "VPN_USER=${var.delugevpn_vpn_user}",
    "VPN_PASS=${var.delugevpn_vpn_password}",
    "ENABLE_PRIVOXY=yes",
    "STRICT_PORT_FORWARD=yes",
    "LAN_NETWORK=192.168.0.0/24",
    "NAME_SERVERS=84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1",
    "DEBUG=false",
    "DELUGE_DAEMON_LOG_LEVEL=warn",
    "DELUGE_WEB_LOG_LEVEL=warn",
    "DELUGE_ENABLE_WEBUI_PASSWORD=yes",
    "UMASK=000",
    "PUID=${var.local_uid}",
    "PGID=${var.local_gid}"
  ]

  networks_advanced {
    name = var.network
  }

  capabilities {
    add = ["NET_ADMIN"]
  }

  dynamic "volumes" {
    for_each = var.mount_volumes
    content {
      container_path = volumes.value.container_path
      host_path      = volumes.value.host_path
      read_only      = volumes.value.read_only
    }
  }

  volumes {
    container_path = "/etc/localtime"
    host_path      = "/etc/localtime"
    read_only      = true
  }

  ports {
    internal = 8112
    external = 8112
  }
}
