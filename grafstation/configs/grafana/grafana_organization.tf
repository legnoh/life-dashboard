resource "grafana_organization" "main" {
  name         = "Main Org."
  admin_user   = "admin"
  admins = [
    "anonymous"
  ]
}
