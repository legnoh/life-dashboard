resource "grafana_library_panel" "calendar" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.etc.uid
  name       = "予定"
  model_json = jsonencode(merge(local.calendar_base, local.table_base, {
    targets = [{
        columns = [
          {
            selector = "title"
            text = "title"
            type = "string"
          },
          {
            selector = "startFormatted"
            text = "start"
            type = "string"
          },
          {
            selector = "calendar"
            text = "カレンダー"
            type = "string"
          }
        ]
        datasource = local.calendar
        format = "dataframe"
        hide = false
        parser = "backend"
        refId = "A"
        source = "url"
        type = "json"
        url = "/events"
        url_options = {
          method = "GET"
        }
    }]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        custom = {
          align = "auto",
          cellOptions = {
            type = "color-background",
            applyToRow = true,
            mode = "gradient",
            wrapText = false
          },
          inspect = false,
          filterable = true
        },
        mappings = [{
          options = {
            "個人" = {
              color = "super-light-purple",
              index = 0,
              text = "個人"
            }
            "家族" = {
              color = "super-light-green",
              index = 1,
              text = "家族"
            },
            "仕事" = {
              color = "super-light-yellow",
              index = 2,
              text = "仕事"
            },
            "休日" = {
              color = "super-light-red",
              index = 3,
              text = "休日"
            },
            "Connpass" = {
              color = "super-light-blue",
              index = 4,
              text = "イベント"
            },
          },
          type = "value"
        }],
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["transparent", null]),
          ]
        })
      })
    })
  }))
}
