resource "grafana_library_panel" "pollen-forecast" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.atmosphere.uid
  name       = "Pollen - 花粉予測"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "花粉予測",
    targets = [merge(local.target_base, {
      expr = "max(google_pollen_type_upi) or vector(0)"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        mappings = [
          {
            type    = "range",
            options = { from = 0, to = 0, result = { index = 1, color = "green", text = "無🥰" } },
          },
          {
            type    = "range",
            options = { from = 1, to = 1, result = { index = 2, color = "super-light-green", text = "少😎" } },
          },
          {
            type    = "range",
            options = { from = 2, to = 2, result = { index = 3, color = "green", text = "低🤨" } },
          },
          {
            type    = "range",
            options = { from = 3, to = 3, result = { index = 4, color = "yellow", text = "中😷" } },
          },
          {
            type    = "range",
            options = { from = 4, to = 4, result = { index = 5, color = "orange", text = "多🤧" } },
          },
          {
            type    = "range",
            options = { from = 5, to = 5, result = { index = 6, color = "red", text = "甚😵" } },
          },
        ]
      })
    })
  }))
}
