resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
  keep_locally = true
}

resource "docker_container" "pihole" {
  image = docker_image.pihole.image_id
  name = "pihole${var.instance_number}"
  restart = "unless-stopped"
  hostname = "pihole${var.instance_number}"

  networks_advanced {
    name = var.network
  }
  
  dynamic "volumes" {
    for_each = var.pihole_volumes
    content {
      container_path = volumes.value.container_path
      host_path = "${volumes.value.host_prefix}/pihole${var.instance_number}/${volumes.value.host_suffix}"
      read_only = volumes.value.read_only
    }
  }

  env = [
    "TZ=${var.timezone}",
    "WEBPASSWORD=pa55word",
    "DNSMASQ_LISTENING=all",
    "PIHOLE_DNS_=${var.pihole_dns_origins}",
    "FTLCONF_LOCAL_IPV4=${var.local_ip}"
    ]

    ports {
        internal = 80
        external = 8083 + var.instance_number
        protocol = "tcp"
    }
}