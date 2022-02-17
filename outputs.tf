output "IP_address" {
  value       = module.container["nodered"].IP_address
  description = "the ip address and extrenal port of the container"
  sensitive   = true
}

output "container_name" {
  value       = module.container["nodered"].container_name
  description = "the name of the container"
}
