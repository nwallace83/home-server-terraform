variable "network" {
  type = string
}

variable "dns_server" {
  type = string
}

variable "delugevpn_vpn_user" {
  type = string
}

variable "delugevpn_vpn_password" {
  type = string
}

variable "local_uid" {
  type = number
}

variable "local_gid" {
  type = number
}

variable "mount_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
}