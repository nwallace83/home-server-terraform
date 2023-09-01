variable "name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "timezone" {
  type = string
}

variable "pihole_web_port" {
  type = number
}

variable "network" {
  type = string
}

variable "pihole_dns_origins" {
  type = string
}

variable "pihole_volumes" {
  type = list
}

variable "instance_number" {
  type = number
}