variable "app_name" {
  type    = string
  default = "handbrake"
}

variable "timezone" {
  type = string
}

variable "local_domain" {
  type = string
}

variable "local_tls_secret_name" {
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
