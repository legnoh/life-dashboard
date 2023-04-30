resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "prometheus"
  url  = "http://prometheus:9090"
  is_default = true
}
