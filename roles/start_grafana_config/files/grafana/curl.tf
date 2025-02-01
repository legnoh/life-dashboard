# https://grafana.com/grafana/dashboards/15797-node-exporter-mac-osx/
data "curl" "node-exporter-macos" {
  http_method = "GET"
  uri         = "https://raw.githubusercontent.com/cppalliance/grafana-dashboards/refs/heads/master/node-exporter-macosx/dashboard.json"
}
