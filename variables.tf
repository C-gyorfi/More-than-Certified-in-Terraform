variable "ext_port" {
  type = number
  default = 1880
}

variable "int_port" {
  type = number
  default = 1880

  validation {
    condition = var.int_port <= 65535 && var.int_port > 0
    error_message = "The internal port must be in the valid port range 0 - 65535."
  }
}

variable "countainer_count" {
  type = number
  default = 1
}
