resource "grafana_library_panel" "remo-temperature" {
  org_id = grafana_organization.main.org_id
  name   = "NatureRemo - 温度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "部屋の温度",
    targets = [merge(local.target_base, {
      expr = "remo_temperature{name=\"${var.NATURE_REMO_DEVICE_NAME}\"}"
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

resource "grafana_library_panel" "remo-humidity" {
  org_id = grafana_organization.main.org_id
  name   = "NatureRemo - 湿度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "部屋の湿度",
    targets = [merge(local.target_base, {
      expr = "remo_humidity{name=\"${var.NATURE_REMO_DEVICE_NAME}\"}",
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

resource "grafana_library_panel" "remo-thi" {
  org_id = grafana_organization.main.org_id
  name   = "NatureRemo - 不快指数"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.openweather, {
    title = "中: 不快指数",
    targets = [
      merge(local.target_base, {
        expr = "(0.81 * remo_temperature{name=\"${var.NATURE_REMO_DEVICE_NAME}\"}) + (0.01 * remo_humidity{name=\"${var.NATURE_REMO_DEVICE_NAME}\"}) * ( (0.99 * remo_temperature{name=\"${var.NATURE_REMO_DEVICE_NAME}\"}) - 14.3 ) + 46.3"
        refId = "A"
      }),
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        mappings = locals.thi_threshold
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "remo-power-consumption" {
  org_id = grafana_organization.main.org_id
  name   = "NatureRemo - 瞬間消費電力"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "瞬間消費電力",
    targets = [merge(local.target_base, {
      expr = "remo_measured_instantaneous_energy_watt"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["green", 500]),
            zipmap(local.thresholds_keys, ["yellow", 1000]),
            zipmap(local.thresholds_keys, ["orange", 2000]),
            zipmap(local.thresholds_keys, ["red", 2500]),
          ]
        })
        unit = "watt"
      })
    })
  }))
}
