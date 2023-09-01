variable "networks" {
  type = list
  description = "List of networks for nginx to connect to"
}

variable "nginx_config_file" {
  type = string
  description = "Path to nginx config file"
}