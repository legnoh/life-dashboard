resource "grafana_library_panel" "asken-score" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "asken-score"
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
            zipmap(local.thresholds_keys, ["orange", 40]),
            zipmap(local.thresholds_keys, ["yellow", 50]),
            zipmap(local.thresholds_keys, ["super-light-green", 60]),
            zipmap(local.thresholds_keys, ["light-green", 70]),
            zipmap(local.thresholds_keys, ["green", 80]),
          ]
        })
      })
    })
  }))
}
