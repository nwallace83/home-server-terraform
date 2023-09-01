resource "docker_image" "prowlarr" {
  name = "linuxserver/prowlarr:latest"
  keep_locally = true
}

resource "docker_container" "prowlarr" {
  image = docker_image.prowlarr.image_id
  name = "prowlarr"

  env = [ 
    "TZ=America/Denver",
    "PUID=${var.local_uid}",
    "PGID=${var.local_gid}"
  ]

  restart = "unless-stopped"
  dns = [ var.dns_server ]

  networks_advanced {
    name = var.network
  }

  dynamic "volumes" {
    for_each = var.mount_volumes
    content {
      container_path = volumes.value.container_path
      host_path = volumes.value.host_path
      read_only = volumes.value.read_only
    }
  }

  volumes {
    container_path  = "/etc/localtime"
    host_path = "/etc/localtime"
    read_only = true
  }

  ports {
    internal = 9696
    external = 8083
  }
}