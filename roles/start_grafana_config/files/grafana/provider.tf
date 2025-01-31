provider "grafana" {
  url = "http://${var.GRAFANA_HOST}/"
}

provider "curl" {
}
