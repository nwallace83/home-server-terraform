module "sickchill" {
  source = "./sickchill"

  volumes   = var.sickchill_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "radarr" {
  source = "./radarr"

  volumes   = var.radarr_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "prowlarr" {
  source = "./prowlarr"

  volumes   = var.prowlarr_volumes
  local_uid = var.local_uid
  local_gid = var.local_gid
}

#####################################################################################################################

module "delugevpn" {
  source = "./delugevpn"

  volumes                = var.delugevpn_volumes
  local_uid              = var.local_uid
  local_gid              = var.local_gid
  delugevpn_vpn_password = var.delugevpn_vpn_password
  delugevpn_vpn_user     = var.delugevpn_vpn_user
}

#####################################################################################################################

module "plex" {
  source = "./plex"

  volumes  = var.plex_volumes
  local_ip = var.local_ip
}

#####################################################################################################################

module "handbrake" {
  source = "./handbrake"

  volumes = var.plex_volumes
}

#####################################################################################################################

module "pihole" {
  source = "./pihole"

  volumes            = var.pihole_volumes
  local_ip           = var.local_ip
  local_uid          = var.local_uid
  local_gid          = var.local_gid
  pihole_dns_origins = var.pihole_dns_origins
  password           = var.password
}

#####################################################################################################################

module "ingress" {
  source = "./ingress"

  ingress_namespace        = var.ingress_namespace
  delugevpn_service_port   = module.delugevpn.delugevpn_service_port
  handbrake_service_port   = module.handbrake.handbrake_service_port
  pihole_http_service_port = module.pihole.pihole_http_service_port
  plex_service_port        = module.plex.plex_service_port
  prowlarr_service_port    = module.prowlarr.prowlarr_service_port
  radarr_service_port      = module.radarr.radarr_service_port
  sickchill_service_port   = module.sickchill.sickchill_service_port
}

#####################################################################################################################
