variable "app_name" {
  type    = string
  default = "dashboard"
}

variable "local_domain" {
  type = string
}

variable "dashboard_namespace" {
  type        = string
}

variable "tls_certificate" {
  type = string
}

variable "tls_key" {
  type = string
}
