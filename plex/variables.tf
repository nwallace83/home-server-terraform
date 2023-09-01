variable "local_ip" {
  type = string
  description = "Local IP address"
}

variable "timezone" {
  type = string
  description = "Local timezone.... i.e. America/Denver"
}

variable "network" {
  type = string
  description = "Docker network name"
}

variable "plex_volumes" {
  type = list
  description = "List of docker volumes to be mounted by Plex"
}

variable "dns_server" {
  type = string
  description = "IP address of the server to use for dns"
}