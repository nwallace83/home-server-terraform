variable "networks" {
  type = list
  description = "List of networks for nginx to connect to"
}

variable "nginx_config_file" {
  type = string
  default = "/Users/nate/Google Drive/My Drive/Projects/home-server-terraform/pihole_nginx/nginx.conf"
  description = "Path to nginx config file"
}

variable "timezone" {
  type = string
  default = "America/Denver"
  description = "Timezone for nginx_pihole"
}