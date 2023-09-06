variable "local_uid" {
  type = number
}

variable "local_gid" {
  type = number
}

variable "app_name" {
  type    = string
  default = "radarr"
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
}
