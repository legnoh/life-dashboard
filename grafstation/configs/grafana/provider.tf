provider "grafana" {
  url    = "http://${var.GRAFANA_HOST}/"
  auth   = "admin:admin"
}

provider "curl" {
}
