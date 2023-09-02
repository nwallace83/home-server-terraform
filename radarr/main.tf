resource "docker_image" "radarr" {
  name = "linuxserver/radarr:latest"
  keep_locally = true
}

resource "docker_container" "radarr" {
  image = docker_image.radarr.image_id
  name = "radarr"
  restart = "unless-stopped"
  dns = [ var.dns_server, "1.1.1.1" ]

  env = [ 
    "TZ=America/Denver",
    "PUID=${var.local_uid}",
    "PGID=${var.local_gid}"
  ]

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
    internal = 7878
    external = 8082
  }
}