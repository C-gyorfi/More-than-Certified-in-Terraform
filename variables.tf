variable "env" {
  type = string
  default = "dev"
}

variable "image" {
  type = map
  description = "image for container"
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = list

  validation {
    condition = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 1
    error_message = "The external port must be in the valid port range 0 - 65535."
  }
}

variable "int_port" {
  type = number
  default = 1880

  validation {
    condition = var.int_port <= 65535 && var.int_port > 0
    error_message = "The internal port must be in the valid port range 0 - 65535."
  }
}

locals {
  countainer_count = length(var.ext_port)
}

# variable "countainer_count" {
#   type = number
#   default = 1
# }
