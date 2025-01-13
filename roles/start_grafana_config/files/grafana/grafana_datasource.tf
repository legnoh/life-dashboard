resource "grafana_data_source" "prometheus" {
  org_id     = grafana_organization.main.org_id
  type       = "prometheus"
  name       = "prometheus"
  url        = "http://prometheus:9090"
  is_default = true
}
