variable "local_ip" {
  type = string
}

variable "app_name" {
  type    = string
  default = "plex"
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
