provider "grafana" {
  url  = "http://${var.GRAFANA_HOST}/"
  auth = "anonymous"
}
