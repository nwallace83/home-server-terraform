resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
  keep_locally = true
}

resource "docker_container" "pihole" {
  image = docker_image.pihole.image_id
  name = var.name
  restart = "unless-stopped"
  hostname = var.hostname

  networks_advanced {
    name = var.network
  }
  
  dynamic "volumes" {
    for_each = var.pihole_volumes
    content {
      container_path = volumes.value.container_path
      host_path = "${volumes.value.host_prefix}/pihole${var.instance_number}/${volumes.value.host_suffix}"
    }
  }

  env = [
    "TZ=${var.timezone}",
    "WEBPASSWORD=pa55word",
    "DNSMASQ_LISTENING=all",
    "PIHOLE_DNS_=${var.pihole_dns_origins}"
    ]

    ports {
        internal = 80
        external = var.pihole_web_port
        protocol = "tcp"
    }
}