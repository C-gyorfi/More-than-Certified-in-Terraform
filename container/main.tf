resource "docker_container" "nodered_container" {
  name  = var.name
  image = var.image
  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
