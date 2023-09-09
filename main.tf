module "sickchill" {
  source = "./sickchill"

  volumes               = var.sickchill_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "radarr" {
  source = "./radarr"

  volumes               = var.radarr_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "prowlarr" {
  source = "./prowlarr"

  volumes               = var.prowlarr_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "delugevpn" {
  source = "./delugevpn"

  volumes                = var.delugevpn_volumes
  local_uid              = var.local_uid
  local_gid              = var.local_gid
  delugevpn_vpn_password = var.delugevpn_vpn_password
  delugevpn_vpn_user     = var.delugevpn_vpn_user
  timezone               = var.timezone
  local_domain           = var.local_domain
  local_tls_secret_name  = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "plex" {
  source = "./plex"

  volumes               = var.plex_volumes
  local_ip              = var.local_ip
  timezone              = var.timezone
  local_domain          = var.local_domain
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "handbrake" {
  source = "./handbrake"

  volumes               = var.plex_volumes
  timezone              = var.timezone
  local_domain          = var.local_domain
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "dashboard" {
  source = "./dashboard"

  tls_certificate     = var.tls_certificate
  tls_key             = var.tls_key
  dashboard_namespace = var.dashboard_namespace
}

#####################################################################################################################

module "service_account" {
  source = "./service-account"

  dashboard_namespace = var.dashboard_namespace
}

#####################################################################################################################

module "pihole" {
  source = "./pihole"

  local_ip              = var.local_ip
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  pihole_dns_origins    = var.pihole_dns_origins
  password              = var.password
  timezone              = var.timezone
  local_domain          = var.local_domain
  pihole_custom_list    = var.pihole_custom_list
  local_tls_secret_name = module.ingress_tcp_udp.local_tls_secret_name
}

#####################################################################################################################

module "ingress_tcp_udp" {
  source = "./ingress-tcp-udp"

  ingress_namespace = var.ingress_namespace
  tls_certificate   = var.tls_certificate
  tls_key           = var.tls_key
}

#####################################################################################################################
