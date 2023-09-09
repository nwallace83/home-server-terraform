variable "local_ip" {
  type        = string
  description = "Local IP address"
}

variable "pihole_dns_origins" {
  type        = string
  default     = "1.1.1.1;8.8.8.8;8.8.4.4"
  description = "List of remote DNS servers for pihole backend"
}

variable "delugevpn_vpn_user" {
  type        = string
  description = "VPN username for delugevpn"
}

variable "delugevpn_vpn_password" {
  type        = string
  description = "VPN password for delugevpn"
}

variable "local_uid" {
  type        = number
  default     = 1000
  description = "Local *nix uid"
}

variable "local_gid" {
  type        = number
  default     = 1000
  description = "Local *nix gid"
}

variable "password" {
  type = string
}

variable "ingress_namespace" {
  type        = string
  default     = "ingress"
  description = "Namespace for kubernetes ingress"
}

variable "dashboard_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace for kubernetes ingress"
}

variable "timezone" {
  type        = string
  default     = "America/Denver"
  description = "Timezone for containers - default America/Denver"
}

variable "local_domain" {
  type        = string
  default     = "local"
  description = "Domain for ingress' - default local"
}

variable "tls_certificate" {
  type        = string
  default     = ""
  description = "Base 64 encoded tls certificate"
}

variable "tls_key" {
  type        = string
  default     = ""
  description = "Base 64 encoded tls key"
}

variable "pihole_custom_list" {
  type        = string
  default     = ""
  description = "Contents of custom.list file for local dns lookups"
}

variable "namespace" {
  type        = string
  default     = "home-server"
  description = "Contents of custom.list file for local dns lookups"
}

#####################################################################################################################

variable "plex_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by Plex"
}

variable "delugevpn_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by delugevpn"
}

variable "handbrake_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by handbrake"
}

variable "prowlarr_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by prowlarr"
}

variable "radarr_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by radarr"
}

variable "sickchill_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by sickchill"
}
