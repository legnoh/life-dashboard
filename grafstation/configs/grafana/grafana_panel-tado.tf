resource "grafana_library_panel" "tado-temperature" {
  name = "Tado - 温度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.tado, {
    title = "部屋の温度",
    targets = [merge(local.target_base, {
      expr = "tado_zone_temperature_celsius{zone_name=\"Air Conditioning\"}"
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

resource "grafana_library_panel" "tado-humidity" {
  name = "Tado - 湿度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.tado, {
    title = "部屋の湿度",
    targets = [merge(local.target_base, {
      expr = "tado_zone_humidity_percentage{zone_name=\"Air Conditioning\"}",
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
