resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx_pihole" {
  image = docker_image.nginx.image_id

  name = "nginx_pihole"
  hostname = "nginx_pihole"
  restart = "unless-stopped"
  env = [ "TZ=${var.timezone}" ]

  dynamic "networks_advanced" {
    for_each = var.networks
    content {
      name = networks_advanced.value.id
    }
  }

  ports {
    external = 53
    internal = 53
    protocol = "udp"
  }

  ports {
    external = 53
    internal = 53
    protocol = "tcp"
  }

  volumes {
    container_path = "/etc/nginx/nginx.conf"
    host_path = var.nginx_config_file
    read_only = true
  }
}

output "media_ip_address" {
  value = docker_container.nginx_pihole.network_data[index(docker_container.nginx_pihole.network_data.*.network_name,"media")].ip_address
}