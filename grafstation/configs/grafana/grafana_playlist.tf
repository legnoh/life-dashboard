resource "grafana_playlist" "life-dashboard-refresh" {
  interval = "15m"
  item {
    title = grafana_dashboard.life-metrics.uid
    order = 1
  }
  name = "life-dashboard-refresh"
}
