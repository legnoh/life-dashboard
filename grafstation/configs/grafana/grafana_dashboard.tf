resource "grafana_dashboard" "life-metrics" {
  config_json = jsonencode({
    title       = "life-metrics",
    description = "Now Channel: ${var.TV_CHANNEL_ID1}",
    timezone    = "browser",
    version     = 0,
    refresh     = "5m"
    panels = [

      # channel1
      {
        libraryPanel = zipmap(local.libpanel_keys, [
          var.TV_CHANNEL_ID1 != "" ?
            var.IS_TV_CHANNEL1_MUTED ? 
              grafana_library_panel.tv-muted.uid : grafana_library_panel.tv.uid
          :
            grafana_library_panel.youtube-nightmode-muted.uid
        ])
        gridPos = { h = 8, w = 9, x = 0, y = 0 }
      },

      # channel2/youtube
      {
        libraryPanel = zipmap(local.libpanel_keys, [
          var.TV_CHANNEL_ID2 != "" ?
          var.IS_TV_CHANNEL2_MUTED ?
          grafana_library_panel.tv2-muted.uid : grafana_library_panel.tv2.uid
          : var.IS_YOUTUBE_MUTED ?
          grafana_library_panel.youtube-muted.uid : grafana_library_panel.youtube.uid
        ])
        gridPos = { h = 8, w = 9, x = 0, y = 8 }
      },

      # clock
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.clock.uid])
        gridPos      = { h = 4, w = 3, x = 21, y = 0 }
      },

      ### asken
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.asken-score.uid])
        gridPos      = { h = 4, w = 3, x = 9, y = 4 }
      },

      # moneyforward
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balance.uid])
        gridPos      = { h = 4, w = 3, x = 15, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balancesheet.uid])
        gridPos      = { h = 4, w = 3, x = 18, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-deposit-withdrawal.uid])
        gridPos      = { h = 4, w = 3, x = 21, y = 12 }
      },

      # openweather
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-condition.uid])
        gridPos      = { h = 4, w = 3, x = 18, y = 0 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-temperature.uid])
        gridPos      = { h = 4, w = 3, x = 21, y = 2 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-humidity.uid])
        gridPos      = { h = 4, w = 3, x = 21, y = 5 }
      },

      # smartmeter
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.smartmeter-power-consumption.uid])
        gridPos      = { h = 4, w = 3, x = 9, y = 0 }
      },

      # snmp
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.snmp-in-octets.uid])
        gridPos      = { h = 4, w = 3, x = 12, y = 4 }
      },

      # speedtest
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.speedtest-score.uid])
        gridPos      = { h = 4, w = 3, x = 12, y = 0 }
      },

      # tado
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.tado-temperature.uid])
        gridPos      = { h = 4, w = 3, x = 18, y = 2 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.tado-humidity.uid])
        gridPos      = { h = 4, w = 3, x = 18, y = 5 }
      },

      # todoist
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.todoist-tasknum.uid])
        gridPos      = { h = 4, w = 3, x = 15, y = 0 }
      },

      # withings
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bmi.uid])
        gridPos      = { h = 4, w = 3, x = 9, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-fat-ratio.uid])
        gridPos      = { h = 4, w = 3, x = 12, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bpm-max.uid])
        gridPos      = { h = 4, w = 3, x = 15, y = 3 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bpm-min.uid])
        gridPos      = { h = 4, w = 3, x = 15, y = 6 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-steps.uid])
        gridPos      = { h = 4, w = 3, x = 12, y = 12 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-sleep-score.uid])
        gridPos      = { h = 4, w = 3, x = 9, y = 12 }
      },

      # news
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news.uid])
        gridPos      = { h = 4, w = 6, x = 9, y = 15 }
      },
    ]
  })
}
