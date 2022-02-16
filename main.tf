module "image" { 
  source = "./image"
  for_each = var.image
  image_in = each.value[terraform.workspace]
}

resource "random_string" "random" {
  count   = local.countainer_count
  length  = 4
  special = false
  upper   = false
}

module "container" {
  depends_on = [module.image]
  source = "./container"
  count = local.countainer_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = module.image["nodered"].image_out
  internal_port = var.int_port
  external_port = var.ext_port[terraform.workspace][count.index]
  container_path = "/data"
}
