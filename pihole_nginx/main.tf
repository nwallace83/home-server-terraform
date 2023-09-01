resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "pihole_nginx" {
  image = docker_image.nginx.image_id

  name = "pihole_nginx"
  hostname = "pihole_nginx"
  restart = "unless-stopped"
  env = [ "TZ=America/Denver" ]

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
  value = docker_container.pihole_nginx.network_data[index(docker_container.pihole_nginx.network_data.*.network_name,"media")].ip_address
}