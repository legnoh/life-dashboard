# Create a grafana-kiosk user to bypass the admin password reset UI
resource "grafana_user" "kiosk" {
  email    = "kiosk@localhost"
  name     = "grafana-kiosk"
  login    = "grafana-kiosk"
  password = "grafana-kiosk"
  is_admin = true
}
