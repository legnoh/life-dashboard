resource "grafana_organization" "main" {
  name         = "Main Org."
  create_users = true
  admins = [
    grafana_user.kiosk.email
  ]
}
