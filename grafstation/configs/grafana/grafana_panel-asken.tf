resource "grafana_library_panel" "asken-score" {
  name = "あすけん - 健康度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.asken, {
    title = "あすけん健康度",
    targets = [merge(local.target_base, {
      expr = "asken_score{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 30]),
            zipmap(local.thresholds_keys, ["yellow", 40]),
            zipmap(local.thresholds_keys, ["super-light-green", 50]),
            zipmap(local.thresholds_keys, ["green", 60]),
            zipmap(local.thresholds_keys, ["semi-dark-green", 70]),
            zipmap(local.thresholds_keys, ["dark-green", 80]),
          ]
        })
      })
    })
  }))
}
