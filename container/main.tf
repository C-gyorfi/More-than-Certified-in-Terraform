resource "random_string" "random" {
  count = var.count_in
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = var.count_in
  name  = join("-", [var.name, terraform.workspace, random_string.random[count.index].result])
  image = var.image
  ports {
    internal = var.internal_port
    external = var.external_port[count.index]
  }
  volumes {
    container_path = var.container_path
    volume_name = docker_volume.container_volume[count.index].name
  }
}

resource "docker_volume" "container_volume" {
  count = var.count_in
  name = "${var.name}-${random_string.random[count.index].result}-volume"
  lifecycle {
    prevent_destroy = false
  }
}