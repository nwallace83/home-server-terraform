resource "docker_image" "pihole" {
  name         = "pihole/pihole:latest"
  keep_locally = true
}

resource "docker_container" "pihole" {
  image    = docker_image.pihole.image_id
  name     = "pihole${var.instance_number}"
  restart  = "unless-stopped"
  hostname = "pihole${var.instance_number}"
  dns      = ["127.0.0.1", "1.1.1.1"]

  env = [
    "TZ=${var.timezone}",
    "WEBPASSWORD=pa55word",
    "DNSMASQ_LISTENING=all",
    "PIHOLE_DNS_=${var.pihole_dns_origins}",
    "FTLCONF_LOCAL_IPV4=${var.local_ip}",
    "IPv6=false",
    "MAXDBDAYS=7",
    "FTLCONF_GRAVITYDB=/opt/pihole/gravity.db",
    "FTLCONF_DBFILE=/opt/pihole/pihole-FTL.db"
  ]

  networks_advanced {
    name = var.network
  }

  dynamic "volumes" {
    for_each = var.pihole_volumes
    content {
      container_path = volumes.value.container_path
      host_path      = "${volumes.value.host_prefix}/pihole/${volumes.value.host_suffix}"
      read_only      = volumes.value.read_only
    }
  }

  ports {
    internal = 80
    external = 8083 + var.instance_number
    protocol = "tcp"
  }
}
