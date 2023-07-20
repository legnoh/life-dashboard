resource "grafana_library_panel" "speedtest-score" {
  org_id = grafana_organization.main.org_id
  name = "Speedtest - ダウンロード速度"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "回線速度",
    targets = [merge(local.target_base, {
      expr = "speedtest_downloadedbytes_bytes{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["red", 1000000]),
            zipmap(local.thresholds_keys, ["light-red", 5000000]),
            zipmap(local.thresholds_keys, ["orange", 10000000]),
            zipmap(local.thresholds_keys, ["light-orange", 30000000]),
            zipmap(local.thresholds_keys, ["super-light-orange", 50000000]),
            zipmap(local.thresholds_keys, ["light-green", 100000000]),
            zipmap(local.thresholds_keys, ["green", 300000000]),
            zipmap(local.thresholds_keys, ["semi-dark-green", 500000000]),
            zipmap(local.thresholds_keys, ["dark-green", 1000000000]),
          ]
        })
        unit = "bps"
      })
    })
  }))
}
