resource "docker_image" "plex" {
  name         = "plexinc/pms-docker:latest"
  keep_locally = true
}

resource "docker_container" "plex" {
  image    = docker_image.plex.image_id
  name     = "plex"
  restart  = "unless-stopped"
  hostname = "plex"
  dns      = [var.dns_server, "1.1.1.1"]

  env = [
    "TZ=America/Denver",
    "ADVERTISE_IP=${var.local_ip}:32400/"
  ]

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
    internal = 32400
    external = 32400
    protocol = "tcp"
  }

  ports {
    internal = 3005
    external = 3005
    protocol = "tcp"
  }

  ports {
    internal = 8324
    external = 8324
    protocol = "tcp"
  }

  ports {
    internal = 32469
    external = 32469
    protocol = "tcp"
  }

  ports {
    internal = 1900
    external = 1900
    protocol = "udp"
  }

  ports {
    internal = 32410
    external = 32410
    protocol = "udp"
  }

  ports {
    internal = 32412
    external = 32412
    protocol = "udp"
  }

  ports {
    internal = 32413
    external = 32413
    protocol = "udp"
  }

  ports {
    internal = 32414
    external = 32414
    protocol = "udp"
  }

  networks_advanced {
    name = var.network
  }
}