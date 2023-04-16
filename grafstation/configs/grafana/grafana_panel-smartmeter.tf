resource "grafana_library_panel" "smartmeter-power-consumption" {
  name = "Smartmeter - 消費電力"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "消費電力",
    targets = [merge(local.target_base, {
      expr = "power_consumption_ampare_r{} + power_consumption_ampare_t{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["green", 5000]),
            zipmap(local.thresholds_keys, ["yellow", 10000]),
            zipmap(local.thresholds_keys, ["orange", 20000]),
            zipmap(local.thresholds_keys, ["red", 25000]),
          ]
        })
        unit = "mamp"
      })
    })
  }))
}
