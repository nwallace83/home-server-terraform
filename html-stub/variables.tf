variable "local_domain" {
  type = string
}

variable "app_name" {
  type = string
  default = "html-stub"
}

variable "local_tls_secret_name" {
  type = string
}

variable "namespace" {
  type = string
}
