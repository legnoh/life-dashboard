resource "grafana_organization" "main" {
  name         = "Main Org."
  create_users = true
  admins = [
    grafana_user.admin.email,
    grafana_user.kiosk.email
  ]
}
