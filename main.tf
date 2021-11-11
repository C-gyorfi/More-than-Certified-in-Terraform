terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.12.0"
    }
  }
}

provider "docker" {}

variable "ext_port" {
  type = number
  default = 1880
}

variable "int_port" {
  type = number
  default = 1880
}
variable "countainer_count" {
  type = number
  default = 1
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = var.countainer_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

output "IP_address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "the ip address and extrenal port of the container"
}

output "container_name" {
  value       = docker_container.nodered_container[*].name
  description = "the name of the container"
}
