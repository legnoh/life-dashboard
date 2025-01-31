resource "grafana_library_panel" "clock" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.misc.uid
  name       = "clock"
  model_json = jsonencode({
    type = "grafana-clock-panel",
    options = {
      mode     = "time"
      refresh  = "sec"
      bgColor  = ""
      fontMono = false
      countdownSettings = {
        source           = "input"
        endCountdownTime = "2025-01-31T17:19:26+09:00"
        queryCalculation = "last"
        endText          = "00:00:00"
        noValueText      = "no value found"
        invalidValueText = "invalid value"
      }
      countupSettings = {
        source           = "input"
        beginCountupTime = "2025-01-31T17:19:26+09:00"
        queryCalculation = "last"
        beginText        = "00:00:00"
        noValueText      = "no value found"
        invalidValueText = "invalid value"
      }
      descriptionSettings = {
        source          = "none"
        descriptionText = ""
        noValueText     = "no description found"
        fontSize        = "12px"
        fontWeight      = "normal"
      }
      clockType = "custom"
      timeSettings = {
        fontSize     = "3vw"
        fontWeight   = "bold"
        customFormat = "HH:mm"
      }
      timezone = "Asia/Tokyo"
      timezoneSettings = {
        showTimezone = false
        zoneFormat   = "offsetAbbv"
        fontSize     = "12px"
        fontWeight   = "normal"
      }
      dateSettings = {
        showDate   = true
        dateFormat = "YY/MM/DD(ddd)"
        locale     = "ja"
        fontSize   = "1.5vw"
        fontWeight = "normal"
      }
    },
  })
}
