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
  mount_volumes = var.plex_volumes
  dns_server = module.pihole_nginx.media_ip_address
}

#####################################################################################################################

module "delugevpn" {
  source = "./delugevpn"

  network = docker_network.media.id
  dns_server = module.pihole_nginx.media_ip_address

  delugevpn_vpn_user = var.delugevpn_vpn_user
  delugevpn_vpn_password = var.delugevpn_vpn_password
  mount_volumes = var.delugevpn_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "handbrake" {
  source = "./handbrake"

  network = docker_network.media.id
  dns_server = module.pihole_nginx.media_ip_address

  mount_volumes = var.handbrake_volumes
}

#####################################################################################################################

module "prowlarr" {
  source = "./prowlarr"

  network = docker_network.media.id
  dns_server = module.pihole_nginx.media_ip_address

  mount_volumes = var.prowlarr_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "radarr" {
  source = "./radarr"

  network = docker_network.media.id
  dns_server = module.pihole_nginx.media_ip_address

  mount_volumes = var.radarr_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "sickchill" {
  source = "./sickchill"

  network = docker_network.media.id
  dns_server = module.pihole_nginx.media_ip_address

  mount_volumes = var.sickchill_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

variable "timezones_pihole" {
  type = list
  default = ["America/Denver","America/Los_Angeles"]
}

module "pihole" {
  source = "./pihole"
  count = 2

  local_ip = var.local_ip
  timezone = "${var.timezones_pihole[count.index]}"
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