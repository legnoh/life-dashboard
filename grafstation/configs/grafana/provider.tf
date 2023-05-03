provider "grafana" {
  url    = "http://${var.GRAFANA_HOST}/"
  auth   = "admin:admin"
  org_id = 1 # Main org.
}
