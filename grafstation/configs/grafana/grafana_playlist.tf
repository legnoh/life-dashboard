resource "grafana_playlist" "life-dashboard-refresh" {
  name = "life-dashboard-refresh"
  org_id = grafana_organization.main.org_id
  interval = "15m"
  item {
    title = grafana_dashboard.life-metrics.uid
    order = 1
  }
}
