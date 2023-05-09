resource "grafana_playlist" "life-dashboard-refresh" {
  name = "life-dashboard-refresh"
  interval = "15m"
  item {
    title = "Life Metrics"
    type = "dashboard_by_uid"
    value = grafana_dashboard.life-metrics.uid
    order = 1
  }
}
