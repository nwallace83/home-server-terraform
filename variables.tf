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
  type = string
  default = "ingress"
  description = "Namespace for kubernetes ingress"
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

variable "pihole_volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default     = []
  description = "List of docker volumes to be mounted by pihole"
}
