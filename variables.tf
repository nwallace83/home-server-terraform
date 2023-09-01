variable "local_ip" {
  type = string
  description = "Local IP address"
}

variable "nginx_config_file" {
  type = string
  description = "Path to nginx config file"
}

variable "docker_provider_host" {
  type = string
  description = "Docker provider host"
}

variable "docker_provider_ssh_opts" {
  type = list(string)
  default = []
  description = "Docker provider ssh options"
}

variable "pihole_dns_origins" {
  type = string
  default = "1.1.1.1;8.8.8.8;8.8.4.4"
  description = "List of remote DNS servers for pihole backend"
}

variable "delugevpn_vpn_user" {
  type = string
  description = "VPN username for delugevpn"
}

variable "delugevpn_vpn_password" {
  type = string
  description = "VPN password for delugevpn"
}

variable "local_uid" {
  type = number
  default = 1000
  description = "Local *nix uid"
}

variable "local_gid" {
  type = number
  default = 1000
  description = "Local *nix gid"
}

#####################################################################################################################

variable "pihole_volumes" {
  type = list(object({
    container_path = string
    host_prefix = string
    host_suffix = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by pihole"
}

variable "plex_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by Plex"
}

variable "delugevpn_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by delugevpn"
}

variable "handbrake_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by handbrake"
}

variable "prowlarr_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by prowlarr"
}

variable "radarr_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by radarr"
}

variable "sickchill_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
  description = "List of docker volumes to be mounted by sickchill"
}