variable "local_ip" {
  type = string
  description = "Local IP address"
}

variable "nginx_config_file" {
  type = string
  description = "Path to nginx config file"
}

variable "timezone" {
  type = string
  description = "Local timezone.... i.e. America/Denver"
}

variable "plex_volumes" {
  type = list
  description = "List of docker volumes to be mounted by Plex"
}

variable "docker_provider_host" {
  type = string
  description = "Docker provider host"
}

variable "docker_provider_ssh_opts" {
  type = list(string)
  default = []
  description = "Docker provider ssh options"
}

variable "pihole_dns_origins" {
  type = string
  default = "1.1.1.1;8.8.8.8;8.8.4.4"
  description = "List of remote DNS servers for pihole backend"
}

variable "pihole_volumes" {
  type = list
  default = []
  description = "List of docker volumes to be mounted by pihole"
}