terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.12.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 1880
  }
}

output "IP_address" {
  value       = docker_container.nodered_container.ip_address
  description = "the ip address of the container"
}

output "container_name" {
  value       = docker_container.nodered_container.name
  description = "the name of the container"
}
