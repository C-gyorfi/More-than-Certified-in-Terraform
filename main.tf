module "image" {
  source   = "./image"
  for_each = var.image
  image_in = each.value[terraform.workspace]
}

module "container" {
  depends_on     = [module.image]
  source         = "./container"
  for_each       = local.deployment
  count_in       = each.value.countainer_count
  name           = each.key
  image          = module.image[each.key].image_out
  internal_port  = each.value.int_port
  external_port  = each.value.ext_port
  volumes        = each.value.volumes
}
