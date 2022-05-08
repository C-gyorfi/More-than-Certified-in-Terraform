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
      volume_name    = docker_volume.container_volume[volumes.key].name
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

resource "docker_volume" "container_volume" {
  count = length(var.volumes)
  name  = "${var.name}-${count.index}-volume"
  lifecycle {
    prevent_destroy = false
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup/"
    on_failure = continue
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo hello"
    # command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
    on_failure = fail
  }
}
