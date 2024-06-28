resource "grafana_library_panel" "todoist-office" {
  org_id = grafana_organization.main.org_id
  name   = "Todoist - タスク残数(職場)"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "タスク残数(職場)",
    targets = [
      merge(local.target_base, {
        expr   = "todoist_filter_task_items{name=\"TODO - 職場\"}",
        format = "time_series",
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

resource "grafana_library_panel" "todoist-private" {
  org_id = grafana_organization.main.org_id
  name   = "Todoist - タスク残数(自宅)"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "タスク残数(自宅)",
    targets = [
      merge(local.target_base, {
        expr   = "todoist_filter_task_items{name=\"TODO - 自宅\"}",
        format = "time_series",
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
