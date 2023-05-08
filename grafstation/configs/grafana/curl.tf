# https://grafana.com/grafana/dashboards/1860-node-exporter-full/
data "curl" "node-exporter-full" {
  http_method = "GET"
  uri = "https://grafana.com/api/dashboards/1860/revisions/latest/download"
}
