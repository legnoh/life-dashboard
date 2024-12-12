resource "grafana_dashboard" "life-metrics" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "Life Metrics",
    description = "Ch1:${var.TV_CHANNEL1} M:${var.IS_TV_CHANNEL1_MUTED} / Ch2:${var.TV_CHANNEL2} M:${var.IS_TV_CHANNEL2_MUTED}",
    timezone    = "browser",
    version     = 0,
    refresh     = "30m"
    # timepicker = {
    #   hidden = true
    # }
    panels = var.TV_CHANNEL1 != "fitness" ? [
      # 通常モード
      # channel1
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.channel1.uid])
        gridPos      = { h = 11, w = 9, x = 0, y = 0 }
      },

      # channel2
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.channel2.uid])
        gridPos      = { h = 11, w = 9, x = 0, y = 11 }
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

      # reminders
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.reminders-outdated.uid])
        gridPos      = local.grid_position.C3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.reminders-asap.uid])
        gridPos      = local.grid_position.C2
      },

      # snmp
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.snmp-speedtest-occupancy.uid])
        gridPos      = local.grid_position.D5
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
      ] : [
      # フィットネスモード

      # メイン画面
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.channel1.uid])
        gridPos      = { h = 20, w = 16, x = 4, y = 0 }
      },

      # 左(Oura+あすけん)
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-readiness-score.uid])
        gridPos      = local.panorama_position.L1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-sleep-score.uid])
        gridPos      = local.panorama_position.L2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-activity-score.uid])
        gridPos      = local.panorama_position.L3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.asken-score.uid])
        gridPos      = local.panorama_position.L4
      },

      # 右(時計+天気+外温度+内温度)
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.clock.uid])
        gridPos      = local.panorama_position.R1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-condition.uid])
        gridPos      = local.panorama_position.R2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.openweather-temperature.uid])
        gridPos      = local.panorama_position.R3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-temperature.uid])
        gridPos      = local.panorama_position.R4
      },

      # 下(歩数+体脂肪率+BMI+湿度)
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.oura-steps.uid])
        gridPos      = local.panorama_position.U1
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-fat-ratio.uid])
        gridPos      = local.panorama_position.U2
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.withings-bmi.uid])
        gridPos      = local.panorama_position.U3
      },
      {
        libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.remo-humidity.uid])
        gridPos      = local.panorama_position.U4
      },
    ]
  })
}

resource "grafana_dashboard" "node-exporter" {
  config_json = data.curl.node-exporter-full.response
}

resource "grafana_dashboard" "gch" {
  org_id = grafana_organization.main.org_id
  config_json = jsonencode({
    title       = "GreenCH",
    description = "最終更新",
    timezone    = "browser",
    refresh     = "30m"
    panels      = concat([
      for i, s in var.GCH_STREAMS
      :
          {
            libraryPanel = zipmap(local.libpanel_keys, [
                timecmp(timestamp(), s.end_at) < 0 || s.channel_id == "ch1"
                ?
                  grafana_library_panel.gch[i].uid
                :
                  grafana_library_panel.gch_not_onair.uid])
            gridPos = (
                s.channel_id == "ch1" ?
                  local.gch_position[0]
                :
                s.channel_id == "ch2" ?
                  local.gch_position[1]
                :
                s.channel_id == "ch3" ?
                  local.gch_position[2]
                :
                s.channel_id == "ch4" ?
                  local.gch_position[3]
                :
                s.channel_id == "ch5" ?
                  local.gch_position[4]
                :
                { h = 0, w = 0,  x = 0, y = 0 }
              )
          }
      ],[
        {
          libraryPanel = zipmap(local.libpanel_keys, [grafana_library_panel.news-netkeiba.uid])
          gridPos      = { h = 2, w = 24, x = 0, y = 26 }
        }
      ]
    )
  })
}
