output "IP_address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "the ip address and extrenal port of the container"
}

output "container_name" {
  value       = docker_container.nodered_container[*].name
  description = "the name of the container"
}
