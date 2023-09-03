variable "local_ip" {
  type = string
}

variable "timezone" {
  type    = string
  default = "America/Denver"
}

variable "network" {
  type = string
}

variable "pihole_dns_origins" {
  type = string
}

variable "pihole_volumes" {
  type = list(object({
    container_path = string
    host_prefix    = string
    host_suffix    = string
    read_only      = optional(bool, false)
  }))
  default = []
}

variable "instance_number" {
  type    = number
  default = 0
}