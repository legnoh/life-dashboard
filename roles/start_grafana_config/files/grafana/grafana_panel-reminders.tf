resource "grafana_library_panel" "reminders-outdated" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.todolist.uid
  name       = "リマインダー - タスク残数(期限切れ)"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "タスク残数(期限切れ)",
    targets = [
      merge(local.target_base, {
        expr   = "reminders_all_total{status=\"outdated\"}",
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

resource "grafana_library_panel" "reminders-asap" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.todolist.uid
  name       = "リマインダー - タスク残数(ASAP)"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "タスク残数(ASAP)",
    targets = [
      merge(local.target_base, {
        expr   = "reminders_list_total{name=\"ASAP\"}",
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
