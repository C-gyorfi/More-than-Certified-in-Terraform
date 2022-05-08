resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "container" {
  count = var.count_in
  name  = join("-", [var.name, terraform.workspace, random_string.random[count.index].result])
  image = var.image
  ports {
    internal = var.internal_port
    external = var.external_port[count.index]
  }
  dynamic "volumes" {
    for_each = var.volumes
    content {
      container_path = volumes.value["container_path_each"]
      volume_name    = module.volume[count.index].volume_output[volumes.key]
    }
  }

  provisioner "local-exec" {
    when    = create
    command = "echo ${self.name}:${self.ip_address}:${join("", [for x in self.ports[*]["external"] : x])} >> containers.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf containers.txt"
  }
}

module "volume" {
  source       = "./volume"
  count        = var.count_in
  volume_count = length(var.volumes)
  volume_name  = join("-", [var.name, terraform.workspace, random_string.random[count.index].result, "volume"])
}
 