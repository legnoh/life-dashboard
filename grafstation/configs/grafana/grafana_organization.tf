resource "grafana_organization" "main" {
  name         = "Main Org."
  create_users = true
  admins = [
    grafana_user.kiosk.email
  ]
}

resource "grafana_organization_preferences" "main" {
  org_id     = grafana_organization.main.org_id
  home_dashboard_id = grafana_dashboard.life-metrics.id
  theme      = var.GRAFANA_THEME
}
