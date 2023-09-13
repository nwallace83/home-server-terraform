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

variable "pihole_custom_list" {
  type = string
}

variable "namespace" {
  type = string
}
