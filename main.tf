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

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

resource "docker_container" "nodered_container_multiple" {
  count = 2
  name  = "nodered_${count.index}"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

output "IP_address" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "the ip address and extrenal port of the container"
}

output "container_name" {
  value       = docker_container.nodered_container.name
  description = "the name of the container"
}
