resource "grafana_dashboard" "life-metrics" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "Life Metrics",
    description = "Now CH1: ${var.TV_CHANNEL1_ID}, Muted: ${var.IS_TV_CHANNEL1_MUTED}, CH2: ${var.TV_CHANNEL2_ID}, Muted: ${var.IS_TV_CHANNEL2_MUTED}, YTMuted: ${var.IS_YOUTUBE_MUTED}, DayMode: ${var.IS_DAYMODE}",
    timezone    = "browser",
    version     = 0,
    refresh     = "30m"
    panels = [

      # channel1
      {
        libraryPanel = zipmap(local.libpanel_keys, [
          var.IS_REFRESHTIME ?
            grafana_library_panel.youtube-stretch.uid
          :
          var.IS_RACETIME ?
            var.IS_TV_CHANNEL1_MUTED ?
              grafana_library_panel.greench-muted.uid : grafana_library_panel.greench.uid
          :
          var.TV_CHANNEL1_ID != "" ?
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
          var.TV_CHANNEL2_ID != "" ?
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
        gridPos      = local.grid_position.E1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-world.uid])
        gridPos      = local.grid_position.E2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-business.uid])
        gridPos      = local.grid_position.E3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-sports.uid])
        gridPos      = local.grid_position.E4
      },

      # clock
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.clock.uid])
        gridPos      = local.grid_position.A5
      },

      ### asken
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.asken-score.uid])
        gridPos      = local.grid_position.C1
      },

      # moneyforward
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balance.uid])
        gridPos      = local.grid_position.D1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-balancesheet.uid])
        gridPos      = local.grid_position.D2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.moneyforward-deposit-withdrawal.uid])
        gridPos      = local.grid_position.D3
      },
      
      # nature remo
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-temperature.uid])
        gridPos      = local.grid_position.B4
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-humidity.uid])
        gridPos      = local.grid_position.C4
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-power-consumption.uid])
        gridPos      = local.grid_position.D4
      },

      # openweather
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-condition.uid])
        gridPos      = local.grid_position.A4
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-temperature.uid])
        gridPos      = local.grid_position.B5
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-humidity.uid])
        gridPos      = local.grid_position.C5
      },

      # oura
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-readiness-score.uid])
        gridPos      = local.grid_position.A1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-sleep-score.uid])
        gridPos      = local.grid_position.A3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-activity-score.uid])
        gridPos      = local.grid_position.A2
      },

      # snmp
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.snmp-speedtest-occupancy.uid])
        gridPos      = local.grid_position.D5
      },

      # todoist
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.todoist-office.uid])
        gridPos      = local.grid_position.C3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.todoist-private.uid])
        gridPos      = local.grid_position.C2
      },

      # withings
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bmi.uid])
        gridPos      = local.grid_position.B1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bpm-max.uid])
        gridPos      = local.grid_position.B2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-body-temperature.uid])
        gridPos      = local.grid_position.B3
      },
    ]
  })
}

resource "grafana_dashboard" "node-exporter" {
  config_json = data.curl.node-exporter-full.response
}
