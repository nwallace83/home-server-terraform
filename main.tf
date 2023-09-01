resource "docker_network" "media" {
  name = "media"
  ipam_config {
    subnet = "172.18.0.0/16"
  }
}

resource "docker_network" "pihole" {
  name = "pihole"
  ipam_config {
    subnet = "172.19.0.0/16"
  }
}

#####################################################################################################################

module "plex" {
  source = "./plex"

  local_ip = var.local_ip
  network = docker_network.media.id
  plex_volumes = var.plex_volumes
  dns_server = module.pihole_nginx.media_ip_address
}

#####################################################################################################################

variable "timezones_pihole" {
  type = list
  default = ["America/Denver","America/Los_Angeles"]
}

variable "pihole_web_port" {
  type = list
  default = [8084,8085]
}

module "pihole" {
  source = "./pihole"
  count = 2

  name = "pihole${count.index + 1}"
  hostname = "pihole${count.index + 1}"
  timezone = "${var.timezones_pihole[count.index]}"
  pihole_web_port = var.pihole_web_port[count.index]
  pihole_volumes = var.pihole_volumes
  network = docker_network.pihole.id
  pihole_dns_origins = var.pihole_dns_origins
  instance_number = count.index + 1
}

module "pihole_nginx" {
  source = "./pihole_nginx"
  nginx_config_file = var.nginx_config_file
  networks = [ docker_network.pihole, docker_network.media ]
}

#####################################################################################################################