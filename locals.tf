locals {
  deployment = {
    # nodered = {
    #   countainer_count = length(var.ext_port["nodered"][terraform.workspace])
    #   int_port = var.int_port
    #   ext_port = var.ext_port["nodered"][terraform.workspace]
    #   container_path = "/data"
    # }
    # influxdb = {
    #   countainer_count = length(var.ext_port["influxdb"][terraform.workspace])
    #   int_port = 8086
    #   ext_port = var.ext_port["influxdb"][terraform.workspace]
    #   container_path = "/var/lib/influxdb"
    # }
    grafana = {
      countainer_count = length(var.ext_port["grafana"][terraform.workspace])
      int_port         = 3000
      ext_port         = var.ext_port["grafana"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/grafana" },
        { container_path_each = "/etc/grafana" }
      ]
    }
  }
}
