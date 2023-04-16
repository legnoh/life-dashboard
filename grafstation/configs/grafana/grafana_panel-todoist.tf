resource "grafana_library_panel" "todoist-tasknum" {
  name = "Todoist - タスク残数"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "タスク残数",
    targets = [
      merge(local.target_base, {
        expr         = "todoist_filter_task_items{name=\"TODO - 自宅\"}",
        format       = "time_series",
        legendFormat = "自宅",
        refId        = "A",
      }),
      merge(local.target_base, {
        expr         = "todoist_filter_task_items{name=\"TODO - 職場\"}",
        format       = "time_series",
        legendFormat = "職場",
        refId        = "B",
      }),
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["green", null]),
            zipmap(local.thresholds_keys, ["yellow", 5]),
            zipmap(local.thresholds_keys, ["red", 10]),
          ]
        })
        unit = "個"
      })
    })
  }))
}
