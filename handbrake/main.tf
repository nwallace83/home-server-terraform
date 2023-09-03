resource "docker_image" "handbrake" {
  name         = "jlesage/handbrake:latest"
  keep_locally = true
}

resource "docker_container" "handbrake" {
  image = docker_image.handbrake.image_id
  name  = "handbrake"

  restart = "unless-stopped"
  dns     = [var.dns_server, "1.1.1.1"]

  env = ["TZ=America/Denver"]

  networks_advanced {
    name = var.network
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
    internal = 5800
    external = 5800
  }
}