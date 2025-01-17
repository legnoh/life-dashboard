locals {
  prometheus = {
    type = grafana_data_source.prometheus.type
    uid  = grafana_data_source.prometheus.uid
  }

  common_base = {
    datasource = local.prometheus,
  }

  stats_base = {
    type    = "stat"
    options = local.basic_stat_options
  }

  basic_stat_options = {
    reduceOptions = {
      values = false
      calcs  = ["last"]
      fields = ""
    }
    orientation = "auto"
    textMode    = "auto"
    colorMode   = "value"
    graphMode   = "none"
    justifyMode = "auto"
    text        = {}
  }

  field_config_base = {
    overrides = []
  }

  field_config_default_base = {
    color = {
      "mode" : "thresholds"
    },
    mappings = [],
    noValue  = "(TBD)",
    unit     = "none"
  }

  thresholds_base = {
    mode = "absolute",
  }

  thresholds_keys = [
    "color", "value"
  ]

  link = {
    asken = {
      links = [{
        targetBlank = true,
        title       = "あすけん",
        url         = "https://www.asken.jp",
      }]
    }
    moneyforward = {
      links = [{
        targetBlank = true,
        title       = "MoneyForward",
        url         = "http://moneyforward.com",
      }]
    }
    openweather = {
      links = [{
        targetBlank = true,
        title       = "OpenWeather",
        url         = "https://openweathermap.org",
      }]
    }
    oura = {
      links = [{
        targetBlank = true,
        title       = "Oura",
        url         = "https://cloud.ouraring.com",
      }]
    }
    withings = {
      links = [{
        targetBlank = true,
        title       = "Withings Healthcare",
        url         = "https://healthmate.withings.com/",
      }]
    }
  }

  target_base = {
    datasource   = local.prometheus,
    exemplar     = true,
    format       = "table",
    instant      = false,
    interval     = "",
    legendFormat = "",
    refId        = "A"
  }

  libpanel_keys = ["uid"]

  grid_position = {
    A1 = { h = 5, w = 3, x = 9, y = 0 }   # oura-readiness
    A2 = { h = 5, w = 3, x = 12, y = 0 }  # oura-activity
    A3 = { h = 5, w = 3, x = 15, y = 0 }  # oura-sleep
    A4 = { h = 5, w = 3, x = 18, y = 0 }  # weather
    A5 = { h = 5, w = 3, x = 21, y = 0 }  # clock
    B1 = { h = 5, w = 3, x = 9, y = 4 }   # BMI
    B2 = { h = 5, w = 3, x = 12, y = 4 }  # 血圧
    B3 = { h = 5, w = 3, x = 15, y = 4 }  # 体温
    B4 = { h = 5, w = 3, x = 18, y = 4 }  # 部屋室温
    B5 = { h = 5, w = 3, x = 21, y = 4 }  # 外室温
    C1 = { h = 5, w = 3, x = 9, y = 8 }   # あすけん
    C2 = { h = 5, w = 3, x = 12, y = 8 }  # Todoist(自宅)
    C3 = { h = 5, w = 3, x = 15, y = 8 }  # Todoist(職場)
    C4 = { h = 5, w = 3, x = 18, y = 8 }  # 部屋湿度
    C5 = { h = 5, w = 3, x = 21, y = 8 }  # 外湿度
    D1 = { h = 5, w = 3, x = 9, y = 12 }  # 当月収支
    D2 = { h = 5, w = 3, x = 12, y = 12 } # バランスシート
    D3 = { h = 5, w = 3, x = 15, y = 12 } # 残高確認
    D4 = { h = 5, w = 3, x = 18, y = 12 } # 電力
    D5 = { h = 5, w = 3, x = 21, y = 12 } # 帯域利用率
    E1 = { h = 8, w = 4, x = 9, y = 20 }  # news1
    E2 = { h = 8, w = 4, x = 13, y = 20 } # news2
    E3 = { h = 8, w = 4, x = 17, y = 20 } # news3
    E4 = { h = 8, w = 3, x = 21, y = 20 } # news4
  }

  panorama_position = {
    MAIN = { h = 20, w = 16, x = 4, y = 0 } #メイン画面
    L1   = { h = 7, w = 4, x = 0, y = 0 }   # コンディションスコア
    L2   = { h = 7, w = 4, x = 0, y = 7 }   # 睡眠スコア
    L3   = { h = 7, w = 4, x = 0, y = 14 }  # アクティビティスコア
    L4   = { h = 7, w = 4, x = 0, y = 21 }  # あすけんスコア
    R1   = { h = 7, w = 4, x = 20, y = 0 }  # 時計
    R2   = { h = 7, w = 4, x = 20, y = 7 }  # 天気
    R3   = { h = 7, w = 4, x = 20, y = 14 } # 外温度
    R4   = { h = 7, w = 4, x = 20, y = 21 } # 内温度
    U1   = { h = 8, w = 4, x = 4, y = 20 }  # 歩数
    U2   = { h = 8, w = 4, x = 8, y = 20 }  # 体脂肪率
    U3   = { h = 8, w = 4, x = 12, y = 20 } # BMI
    U4   = { h = 8, w = 4, x = 16, y = 20 } # 内湿度
  }

  gch_position = [
    { h = 15, w = 12, x = 0,  y = 0 },
    { h = 15, w = 12, x = 12, y = 0 },
    { h = 11, w = 8,  x = 0,  y = 15 },
    { h = 11, w = 8,  x = 8,  y = 15 },
    { h = 11, w = 8,  x = 16, y = 15 },
  ]

  thi_threshold = [
    { 
      type = "range",
      options = { from = 0,  to = 55,  result = { index = 0 , color = "dark-blue" , text = "寒🥶" } },
    },
    { 
      type = "range", 
      options = { from = 55, to = 60,  result = { index = 1 , color = "blue" , text = "稍寒😨" } },
    },
    { 
      type = "range", 
      options = { from = 60, to = 65,  result = { index = 2 , color = "super-light-green" , text = "普通-🙂" } },
    },
    { 
      type = "range", 
      options = { from = 65, to = 70,  result = { index = 3 , color = "green" , text = "快適🥰" } },
    },
    { 
      type = "range", 
      options = { from = 70, to = 75,  result = { index = 4 , color = "super-light-yellow" , text = "普通+😊" } },
    },
    { 
      type = "range", 
      options = { from = 75, to = 80,  result = { index = 5 , color = "orange" , text = "稍暑😎" } },
    },
    { 
      type = "range", 
      options = { from = 80, to = 85,  result = { index = 6 , color = "red" , text = "暑😥" } },
    },
    { 
      type = "range", 
      options = { from = 85, to = 120, result = { index = 7 , color = "dark-red" , text = "猛暑🥵" } },
    },
  ]
}
