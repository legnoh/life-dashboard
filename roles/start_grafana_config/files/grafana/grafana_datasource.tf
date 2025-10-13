resource "grafana_data_source" "prometheus" {
  org_id     = grafana_organization.main.org_id
  type       = "prometheus"
  name       = "prometheus"
  url        = "http://prometheus:9090"
  is_default = true
}

resource "grafana_data_source" "calendar" {
  org_id     = grafana_organization.main.org_id
  type       = "yesoreyeram-infinity-datasource"
  name       = "apple-calendar"
  url        = "http://host.docker.internal:9102"
  is_default = false
}
