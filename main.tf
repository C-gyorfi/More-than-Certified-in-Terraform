locals {
  deployment = {
    nodered = {
      int_port = var.int_port
      ext_port = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
    }
    influxdb = {
      int_port = 8086
      ext_port = var.ext_port["influxdb"][terraform.workspace]
      container_path = "/var/lib/influxdb"
    }
  }
}
module "image" { 
  source = "./image"
  for_each = var.image
  image_in = each.value[terraform.workspace]
}

resource "random_string" "random" {
  for_each = local.deployment
  length  = 4
  special = false
  upper   = false
}

module "container" {
  depends_on = [module.image]
  source = "./container"
  for_each = local.deployment
  # count = local.countainer_count
  name  = join("-", [each.key, terraform.workspace, random_string.random[each.key].result])
  image = module.image[each.key].image_out
  internal_port = each.value.int_port
  external_port = each.value.ext_port[0]
  container_path = each.value.container_path
}
