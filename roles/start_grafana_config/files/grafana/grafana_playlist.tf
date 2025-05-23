resource "grafana_playlist" "life-dashboard-refresh" {
  org_id   = grafana_organization.main.org_id
  name     = "life-dashboard-refresh"
  interval = "24h"
  item {
    title = "" # work around of omit blank state
    type  = "dashboard_by_uid"
    value = grafana_dashboard.life-metrics.uid
    order = 1
  }
}
