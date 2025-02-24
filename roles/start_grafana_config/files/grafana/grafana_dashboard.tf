resource "grafana_dashboard" "life-metrics" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "Life Metrics"
    description = "Ch1:${var.TV_CHANNEL1} M:${var.IS_TV_CHANNEL1_MUTED} / Ch2:${var.TV_CHANNEL2} M:${var.IS_TV_CHANNEL2_MUTED}"
    timezone    = "browser"
    timepicker = {
      hidden = true
    }
    version = 0
    panels = [
      # 通常モード
      # channel1
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.channel1.uid])
        gridPos      = { h = 11, w = 9, x = 0, y = 0 }
      },

      # channel2
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.channel2.uid])
        gridPos      = { h = 11, w = 9, x = 0, y = 11 }
      },

      # aphorism
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.aphorism.uid])
        gridPos      = { h = 6, w = 9, x = 0, y = 22 }
      },

      # news
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-domestic.uid])
        gridPos      = local.grid_position.E1
      },
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-world.uid])
        gridPos      = local.grid_position.E2
      },
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-business.uid])
        gridPos      = local.grid_position.E3
      },
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-sports.uid])
        gridPos      = local.grid_position.E4
      },

      # clock
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.clock.uid])
        gridPos      = local.grid_position.A5
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
        }
      },

      ### asken
      {
        title        = "あすけん健康度"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.asken-score.uid])
        gridPos      = local.grid_position.C1
      },

      # moneyforward
      {
        title        = "当月収支"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balance.uid])
        gridPos      = local.grid_position.D1
      },
      {
        title        = "バランスシート"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balancesheet.uid])
        gridPos      = local.grid_position.D2
      },
      {
        title        = "残高足りる?"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-deposit-withdrawal.uid])
        gridPos      = local.grid_position.D3
      },

      # nature remo
      {
        title        = "部屋の温度"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-temperature.uid])
        gridPos      = local.grid_position.B4
      },
      {
        title        = "内: 不快指数"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-thi.uid])
        gridPos      = local.grid_position.C4
      },
      {
        title        = "瞬間消費電力"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-power-consumption.uid])
        gridPos      = local.grid_position.D4
      },

      # openweather
      {
        title        = null
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-condition-icon.uid])
        gridPos      = local.grid_position.A4
      },
      {
        title        = "外: 不快指数"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-thi.uid])
        gridPos      = local.grid_position.C5
      },

      # oura
      {
        title        = "コンディションスコア"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-readiness-score.uid])
        gridPos      = local.grid_position.A1
      },
      {
        title        = "睡眠スコア"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-sleep-score.uid])
        gridPos      = local.grid_position.A3
      },
      {
        title        = "アクティビティスコア"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-activity-score.uid])
        gridPos      = local.grid_position.A2
      },

      # pollen
      {
        title        = "花粉予報"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.pollen-forecast.uid])
        gridPos      = local.grid_position.B5
      },

      # reminders
      {
        title        = "タスク残数(期限切れ)"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.reminders-outdated.uid])
        gridPos      = local.grid_position.C3
      },
      {
        title        = "タスク残数(ASAP)"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.reminders-asap.uid])
        gridPos      = local.grid_position.C2
      },

      # snmp
      {
        title        = "帯域利用率"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.snmp-speedtest-occupancy.uid])
        gridPos      = local.grid_position.D5
      },

      # withings
      {
        title        = "BMI"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bmi.uid])
        gridPos      = local.grid_position.B1
      },
      {
        title        = "最高血圧"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bpm-max.uid])
        gridPos      = local.grid_position.B2
      },
      {
        title        = "体温"
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-body-temperature.uid])
        gridPos      = local.grid_position.B3
      },
    ]
  })
}

resource "grafana_dashboard" "node-exporter" {
  config_json = data.curl.node-exporter-macos.response
}

resource "grafana_dashboard" "gch" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "GreenCH"
    description = ""
    timezone    = "browser"
    version     = 0
    panels      = concat(
      [
        for i, s in var.GCH_STREAMS
        :
        {
          libraryPanel = zipmap(local.libpanel_keys, [s.program_name != "放送休止" ? grafana_library_panel.gch[i].uid : grafana_library_panel.gch_not_onair.uid])
          gridPos = local.gch_position[i]
        }
      ], [
        {
          libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-netkeiba.uid])
          gridPos      = { h = 2, w = 24, x = 0, y = 26 }
        }
      ]
    )
  })
}
