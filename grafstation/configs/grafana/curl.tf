# https://grafana.com/grafana/dashboards/1860-node-exporter-full/
data "curl" "node-exporter-full" {
  http_method = "GET"
  uri = "https://raw.githubusercontent.com/rfmoz/grafana-dashboards/master/prometheus/node-exporter-full.json"
}
