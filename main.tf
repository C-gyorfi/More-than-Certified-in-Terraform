locals {
  deployment = {
    nodered = {
      countainer_count = length(var.ext_port["nodered"][terraform.workspace])
      int_port = var.int_port
      ext_port = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
    }
    influxdb = {
      countainer_count = length(var.ext_port["influxdb"][terraform.workspace])
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

module "container" {
  depends_on = [module.image]
  source = "./container"
  for_each = local.deployment
  count_in = each.value.countainer_count
  name  = each.key
  image = module.image[each.key].image_out
  internal_port = each.value.int_port
  external_port = each.value.ext_port
  container_path = each.value.container_path
}
