module "sickchill" {
  source = "./sickchill"

  volumes               = var.sickchill_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "radarr" {
  source = "./radarr"

  volumes               = var.radarr_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "prowlarr" {
  source = "./prowlarr"

  volumes               = var.prowlarr_volumes
  local_uid             = var.local_uid
  local_gid             = var.local_gid
  timezone              = var.timezone
  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
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
  namespace              = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "plex" {
  source = "./plex"

  volumes               = var.plex_volumes
  local_ip              = var.local_ip
  timezone              = var.timezone
  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "handbrake" {
  source = "./handbrake"

  volumes               = var.handbrake_volumes
  timezone              = var.timezone
  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "html_stub" {
  source = "./html-stub"

  local_domain          = var.local_domain
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "service_account" {
  source = "./service-accounts"

  namespace = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "rollout_cron" {
  source = "./rollout-cron"

  namespace = kubernetes_namespace.project-namespace.metadata.0.name
  service_account = module.service_account.patch_deployment_service_account
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
  namespace             = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

module "ingress_tcp_udp" {
  source = "./ingress-tcp-udp"

  ingress_namespace = var.ingress_namespace
  namespace         = kubernetes_namespace.project-namespace.metadata.0.name
}

#####################################################################################################################

resource "kubernetes_namespace" "project-namespace" {
  metadata {
    name = var.namespace
  }
}
