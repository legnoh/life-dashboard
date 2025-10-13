resource "grafana_library_panel" "calendar" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.etc.uid
  name       = "予定"
  model_json = jsonencode(merge(local.calendar_base, local.table_base, {
    targets = [{
      columns = [
        {
          selector = "title"
          text     = "title"
          type     = "string"
        },
        {
          selector = "startFormatted"
          text     = "start"
          type     = "string"
        },
        {
          selector = "calendar"
          text     = "カレンダー"
          type     = "string"
        }
      ]
      datasource = local.calendar
      format     = "dataframe"
      hide       = false
      parser     = "backend"
      refId      = "A"
      source     = "url"
      type       = "json"
      url        = "/events"
      url_options = {
        method = "GET"
      }
    }]
    fieldConfig = merge({
      defaults = merge(local.field_config_default_base, {
        custom = {
          align = "auto",
          cellOptions = {
            type     = "color-text",
            wrapText = false
          },
          inspect    = false,
          filterable = true
        },
        mappings = [{
          options = {
            "個人" = {
              color = "purple",
              index = 0,
              text  = "個人"
            }
            "家族" = {
              color = "green",
              index = 1,
              text  = "家族"
            },
            "仕事" = {
              color = "yellow",
              index = 2,
              text  = "仕事"
            },
            "休日" = {
              color = "red",
              index = 3,
              text  = "休日"
            },
            "Connpass" = {
              color = "blue",
              index = 4,
              text  = "イベント"
            },
          },
          type = "value"
        }],
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
          ]
        })
      })
      overrides = [
        {
          matcher = {
            id      = "byName"
            options = "start"
          }
          properties = [{
            id    = "custom.width"
            value = 120
          }]
        },
        {
          matcher = {
            id      = "byName"
            options = "カレンダー"
          }
          properties = [{
            id    = "custom.width"
            value = 70
          }]
        }
      ]
    })
  }))
}
