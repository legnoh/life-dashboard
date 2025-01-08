resource "grafana_library_panel" "openweather-temperature" {
  org_id = grafana_organization.main.org_id
  name   = "openweather-temperature"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.openweather, {
    title = "外の温度",
    targets = [merge(local.target_base, {
      expr = "(openweather_temperature{location=\"${var.OPENWEATHER_CITY}\"} - 32)/1.8"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["dark-blue", -5]),
            zipmap(local.thresholds_keys, ["semi-dark-blue", 0]),
            zipmap(local.thresholds_keys, ["light-blue", 5]),
            zipmap(local.thresholds_keys, ["#6ED0E0", 10]),
            zipmap(local.thresholds_keys, ["#EAB839", 15]),
            zipmap(local.thresholds_keys, ["semi-dark-green", 20]),
            zipmap(local.thresholds_keys, ["green", 25]),
            zipmap(local.thresholds_keys, ["orange", 30]),
            zipmap(local.thresholds_keys, ["dark-orange", 35]),
            zipmap(local.thresholds_keys, ["red", 40]),
          ]
        })
        unit = "celsius"
      })
    })
  }))
}

resource "grafana_library_panel" "openweather-humidity" {
  org_id = grafana_organization.main.org_id
  name   = "OpenWeather - 湿度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.openweather, {
    title = "外の湿度",
    targets = [merge(local.target_base, {
      expr = "openweather_humidity{location=\"${var.OPENWEATHER_CITY}\"}",
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["dark-blue", 10]),
            zipmap(local.thresholds_keys, ["light-blue", 20]),
            zipmap(local.thresholds_keys, ["super-light-green", 30]),
            zipmap(local.thresholds_keys, ["green", 40]),
            zipmap(local.thresholds_keys, ["semi-dark-green", 50]),
            zipmap(local.thresholds_keys, ["dark-green", 60]),
            zipmap(local.thresholds_keys, ["dark-yellow", 70]),
            zipmap(local.thresholds_keys, ["orange", 80]),
            zipmap(local.thresholds_keys, ["dark-orange", 90]),
            zipmap(local.thresholds_keys, ["red", 100]),
          ]
        })
        unit = "percent"
      })
    })
  }))
}

resource "grafana_library_panel" "openweather-thi" {
  org_id = grafana_organization.main.org_id
  name   = "openweather-thi"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.openweather, {
    title = "外: 不快指数",
    targets = [
      merge(local.target_base, {
        expr = "(openweather_temperature{location=\"${var.OPENWEATHER_CITY}\"} - 32)/1.8"
        hide = true
        refId = "temp"
      }),
      merge(local.target_base, {
        expr = "openweather_humidity{location=\"${var.OPENWEATHER_CITY}\"}",
        hide = true
        refId = "humd"
      }),
      {
        datasource = {
          name = "Expression"
          type = "__expr__"
          uid = "__expr__"
        }
        expression = "(0.81 * $temp) + (0.01 * $humd) * ( (0.99 * $temp) - 14.3 ) + 46.3",
        hide = false,
        refId = "THI",
        type = "math"
      }
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        mappings = [
          { 
            type = "range",
            options = { from = 0,  to = 55,  result = { index = 0 , color = "dark-blue" , text = "寒🥶" } },
          },
          { 
            type = "range", 
            options = { from = 55, to = 60,  result = { index = 1 , color = "blue" , text = "稍寒" } },
          },
          { 
            type = "range", 
            options = { from = 60, to = 65,  result = { index = 2 , color = "super-light-green" , text = "普通(-)" } },
          },
          { 
            type = "range", 
            options = { from = 65, to = 70,  result = { index = 3 , color = "green" , text = "快適" } },
          },
          { 
            type = "range", 
            options = { from = 70, to = 75,  result = { index = 4 , color = "super-light-yellow" , text = "普通(+)" } },
          },
          { 
            type = "range", 
            options = { from = 75, to = 80,  result = { index = 5 , color = "orange" , text = "稍暑" } },
          },
          { 
            type = "range", 
            options = { from = 80, to = 85,  result = { index = 6 , color = "red" , text = "暑" } },
          },
          { 
            type = "range", 
            options = { from = 85, to = 120, result = { index = 7 , color = "dark-red" , text = "猛暑" } },
          },
        ]
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "openweather-condition" {
  org_id = grafana_organization.main.org_id
  name   = "OpenWeather - 現在の天気"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.openweather, {
    targets = [merge(local.target_base, {
      expr = "openweather_currentconditions{location=\"${var.OPENWEATHER_CITY}\"}",
    })]
    options = {
      colorMode   = "value",
      graphMode   = "none",
      justifyMode = "auto",
      orientation = "auto",
      reduceOptions = {
        calcs  = ["last"],
        fields = "/^currentconditions$/",
        values = false
      },
      text     = {},
      textMode = "value"
    },
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
          ]
        })
        mappings = [{
          type = "value"
          options = {
            "broken clouds" : { color = "super-light-green", index = 53, text = "雲がち", },
            "clear sky" : { color = "dark-green", index = 50, text = "快晴", },
            "drizzle" : { color = "light-blue", index = 11, text = "霧雨", },
            "drizzle rain" : { color = "blue", index = 14, text = "雨+霧雨", },
            "dust" : { color = "purple", index = 46, text = "降塵", },
            "extreme rain" : { color = "semi-dark-blue", index = 23, text = "雨(猛烈)", },
            "few clouds" : { color = "semi-dark-green", index = 51, text = "晴れ", },
            "fog" : { color = "purple", index = 44, text = "霧", },
            "freezing rain" : { color = "super-light-yellow", index = 24, text = "雨氷", },
            "haze" : { color = "super-light-purple", index = 42, text = "煙霧", },
            "heavy intensity drizzle" : { color = "blue", index = 12, text = "霧雨(強)", },
            "heavy intensity drizzle rain" : { color = "semi-dark-blue", index = 15, text = "雨(強)+霧雨", },
            "heavy intensity rain" : { color = "blue", index = 21, text = "雨(強)", },
            "heavy intensity shower rain" : { color = "yellow", index = 27, text = "にわか雨(強)", },
            "heavy shower rain and drizzle" : { color = "yellow", index = 17, text = "にわか雨(強)+霧雨", },
            "heavy shower snow" : { color = "dark-yellow", index = 39, text = "にわか雪(強)", },
            "heavy snow" : { color = "dark-purple", index = 32, text = "大雪", },
            "heavy thunderstorm" : { color = "semi-dark-orange", index = 5, text = "雷(強)", },
            "light intensity drizzle" : { color = "super-light-yellow", index = 10, text = "霧雨(弱)", },
            "light intensity drizzle rain" : { color = "light-blue", index = 13, text = "雨(弱)+霧雨", },
            "light intensity shower rain" : { color = "super-light-yellow", index = 25, text = "にわか雨(弱)", },
            "light rain" : { color = "super-light-blue", index = 19, text = "小雨", },
            "light rain and snow" : { color = "super-light-blue", index = 35, text = "みぞれ(弱)", },
            "light shower snow" : { color = "yellow", index = 37, text = "にわか雪(弱)", },
            "light snow" : { color = "light-purple", index = 30, text = "小雪", },
            "light thunderstorm" : { color = "light-orange", index = 3, text = "雷(弱)", },
            "mist" : { color = "super-light-purple", index = 40, text = "もや", },
            "moderate rain" : { color = "light-blue", index = 20, text = "雨", },
            "overcast clouds" : { color = "text", index = 54, text = "曇り", },
            "proximity shower rain" : { color = "super-light-yellow", index = 29, text = "にわか雨(近)", },
            "ragged shower rain" : { color = "light-yellow", index = 28, text = "にわか雨(時々)", },
            "ragged thunderstorm" : { color = "super-light-orange", index = 6, text = "ときどき雷", },
            "rain and snow" : { color = "blue", index = 36, text = "みぞれ", },
            "sand" : { color = "purple", index = 45, text = "降砂", },
            "sand, dust whirls" : { color = "dark-purple", index = 43, text = "砂塵旋風", },
            "scattered clouds" : { color = "light-green", index = 52, text = "千切れ雲", },
            "shower drizzle" : { color = "super-light-yellow", index = 18, text = "にわか霧雨", },
            "shower rain" : { color = "light-yellow", index = 26, text = "にわか雨", },
            "shower rain and drizzle" : { color = "light-yellow", index = 16, text = "にわか雨+霧雨", },
            "shower sleet" : { color = "dark-yellow", index = 34, text = "にわか凍雨", },
            "shower snow" : { color = "semi-dark-yellow", index = 38, text = "にわか雪", },
            "sleet" : { color = "semi-dark-purple", index = 33, text = "凍雨", },
            "smoke" : { color = "super-light-purple", index = 41, text = "煙", },
            "snow" : { color = "purple", index = 31, text = "雪", },
            "squalls" : { color = "red", index = 48, text = "スコール", },
            "thunderstorm" : { color = "orange", index = 4, text = "雷", },
            "thunderstorm with drizzle" : { color = "light-yellow", index = 8, text = "霧雨+雷", },
            "thunderstorm with heavy drizzle" : { color = "yellow", index = 9, text = "霧雨(強)+雷", },
            "thunderstorm with heavy rain" : { color = "dark-red", index = 2, text = "雷雨(強)", },
            "thunderstorm with light drizzle" : { color = "super-light-yellow", index = 7, text = "霧雨(弱)+雷", },
            "thunderstorm with light rain" : { color = "red", index = 0, text = "雷雨(弱)", },
            "thunderstorm with rain" : { color = "semi-dark-red", index = 1, text = "雷雨", },
            "tornado" : { color = "dark-red", index = 49, text = "竜巻", },
            "very heavy rain" : { color = "blue", index = 22, text = "雨(激)", },
            "volcanic ash" : { color = "semi-dark-purple", index = 47, text = "降灰", }
          }
        }]
      })
    })
  }))
}
