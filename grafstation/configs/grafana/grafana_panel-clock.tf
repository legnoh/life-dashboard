resource "grafana_library_panel" "clock" {
  name = "時計"
  model_json = jsonencode({
    type = "grafana-clock-panel",
    options = {
      mode      = "time",
      refresh   = "sec",
      clockType = "custom",
      timeSettings = {
        fontSize     = "3vw",
        fontWeight   = "bold",
        customFormat = "HH:mm"
      },
      timezone = "Asia/Tokyo",
      dateSettings = {
        showDate   = true,
        dateFormat = "YY/MM/DD(ddd)",
        locale     = "ja",
        fontSize   = "1.5vw",
        fontWeight = "normal"
      }
    },
  })
}
