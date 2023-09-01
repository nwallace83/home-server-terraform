terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.24.0"
    }
  }
}

provider "docker" {
  host = var.docker_provider_host
  ssh_opts = var.docker_provider_ssh_opts
}
