resource "grafana_dashboard" "life-metrics" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "Life Metrics",
    description = "Now CH1: ${var.TV_CHANNEL_ID1}, Muted: ${var.IS_TV_CHANNEL1_MUTED}, CH2: ${var.TV_CHANNEL_ID2}, Muted: ${var.IS_TV_CHANNEL2_MUTED}, YTMuted: ${var.IS_YOUTUBE_MUTED}, DayMode: ${var.IS_DAYMODE}",
    timezone    = "browser",
    version     = 0,
    refresh     = "30m"
    panels = [

      # channel1
      {
        libraryPanel = zipmap(local.libpanel_keys, [
          var.TV_CHANNEL_ID1 != "" ?
            var.IS_TV_CHANNEL1_MUTED ? 
              grafana_library_panel.tv-muted.uid : grafana_library_panel.tv.uid
          :
            var.IS_DAYMODE ?
              var.IS_TV_CHANNEL1_MUTED ?
                grafana_library_panel.youtube-daymode-muted.uid : grafana_library_panel.youtube-daymode-bgm.uid
            :
              var.IS_TV_CHANNEL1_MUTED ?
                grafana_library_panel.youtube-nightmode-muted.uid : grafana_library_panel.youtube-nightmode-bgm.uid
        ])
        gridPos = { h = 11, w = 9, x = 0, y = 0 }
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
        gridPos = { h = 11, w = 9, x = 0, y = 11 }
      },

      # aphorism
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.aphorism.uid])
        gridPos      = { h = 6, w = 9, x = 0, y = 22 }
      },

      # news
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-domestic.uid])
        gridPos      = { h = 8, w = 4, x = 9, y = 20 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-world.uid])
        gridPos      = { h = 8, w = 4, x = 13, y = 20 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-business.uid])
        gridPos      = { h = 8, w = 4, x = 17, y = 20 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-sports.uid])
        gridPos      = { h = 8, w = 3, x = 21, y = 20 }
      },

      # clock
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.clock.uid])
        gridPos      = { h = 5, w = 3, x = 21, y = 0 }
      },

      ### asken
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.asken-score.uid])
        gridPos      = { h = 5, w = 3, x = 9, y = 4 }
      },

      # moneyforward
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balance.uid])
        gridPos      = { h = 5, w = 3, x = 15, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balancesheet.uid])
        gridPos      = { h = 5, w = 3, x = 18, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-deposit-withdrawal.uid])
        gridPos      = { h = 5, w = 3, x = 21, y = 12 }
      },
      
      # nature remo
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-temperature.uid])
        gridPos      = { h = 5, w = 3, x = 18, y = 2 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-humidity.uid])
        gridPos      = { h = 5, w = 3, x = 18, y = 5 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-power-consumption.uid])
        gridPos      = { h = 5, w = 3, x = 9, y = 0 }
      },

      # openweather
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-condition.uid])
        gridPos      = { h = 5, w = 3, x = 18, y = 0 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-temperature.uid])
        gridPos      = { h = 5, w = 3, x = 21, y = 2 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-humidity.uid])
        gridPos      = { h = 5, w = 3, x = 21, y = 5 }
      },

      # oura
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-readiness-score.uid])
        gridPos      = { h = 5, w = 3, x = 12, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-sleep-score.uid])
        gridPos      = { h = 5, w = 3, x = 9, y = 12 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-activity-score.uid])
        gridPos      = { h = 5, w = 3, x = 12, y = 12 }
      },

      # snmp
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.snmp-in-octets.uid])
        gridPos      = { h = 5, w = 3, x = 12, y = 4 }
      },

      # speedtest
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.speedtest-score.uid])
        gridPos      = { h = 5, w = 3, x = 12, y = 0 }
      },

      # todoist
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.todoist-tasknum.uid])
        gridPos      = { h = 5, w = 3, x = 15, y = 0 }
      },

      # withings
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bmi.uid])
        gridPos      = { h = 5, w = 3, x = 9, y = 8 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bpm-max.uid])
        gridPos      = { h = 5, w = 3, x = 15, y = 3 }
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-body-temperature.uid])
        gridPos      = { h = 5, w = 3, x = 15, y = 6 }
      },
    ]
  })
}

resource "grafana_dashboard" "node-exporter" {
  config_json = data.curl.node-exporter-full.response
}
