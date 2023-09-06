variable "local_ip" {
  type = string
}

variable "pihole_dns_origins" {
  type = string
}

variable "password" {
  type = string
}

variable "local_uid" {
  type = number
}

variable "local_gid" {
  type = number
}

variable "app_name" {
  type    = string
  default = "pihole"
}

variable "timezone" {
  type = string
}

variable "local_domain" {
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
