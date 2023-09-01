variable "network" {
  type = string
}

variable "mount_volumes" {
  type = list(object({
    container_path = string
    host_path = string
    read_only = optional(bool, false)
  }))
  default = []
}

variable "dns_server" {
  type = string
}