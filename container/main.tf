resource "docker_container" "nodered_container" {
  name  = var.name
  image = var.image
  ports {
    internal = var.internal_port
    external = var.external_port
  }
  volumes {
    container_path = var.container_path
    volume_name = docker_volume.container_volume.name
  }
}

resource "docker_volume" "container_volume" {
  name = "${var.name}-volume"
}