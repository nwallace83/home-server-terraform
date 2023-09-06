variable "local_ip" {
  type = string
}

variable "pihole_dns_origins" {
  type = string
}

variable "password" {
  type = string
}

variable "volumes" {
  type = list(object({
    name           = string
    container_path = string
    host_path      = string
    read_only      = optional(bool, false)
    type           = optional(string, "DirectoryOrCreate")
  }))
  default = []
}