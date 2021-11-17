variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map(any)

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 1
    error_message = "The external port must be in the valid port range 0 - 65535."
  }

  validation {
    condition     = max(var.ext_port["prod"]...) <= 1984 && min(var.ext_port["prod"]...) >= 1980
    error_message = "The external port must be in the valid port range 1980 - 1984."
  }
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port <= 65535 && var.int_port > 0
    error_message = "The internal port must be in the valid port range 0 - 65535."
  }
}

locals {
  countainer_count = length(var.ext_port[terraform.workspace])
}

# variable "countainer_count" {
#   type = number
#   default = 1
# }
