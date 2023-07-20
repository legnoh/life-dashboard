resource "grafana_library_panel" "aphorism" {
  org_id = grafana_organization.main.org_id
  name = "aphorism"
  model_json = jsonencode(merge(local.common_base, {
    type = "canvas",
    targets = [merge(local.target_base, {
      expr = "aphorism_info",
    })],
    transformations = [{
      id = "labelsToFields",
      options = {
        mode = "columns",
      }
    }],
    options = {
      inlineEditing = false,
      root = {
        type = "frame",
        elements = [
          {
            config = {
              align = "center",
              valign = "middle",
              color = {
                fixed = "text"
              },
              text = {
                field = "aphorism",
                mode = "field"
              },
              size = 30
            },
            background = {
              color = {
                fixed = "transparent"
              }
            },
            placement = {
              top = 0,
              height = 182,
              left = 0,
              width = 666
            },
            type = "metric-value",
            name = "body",
            constraint = {
              vertical = "center",
              horizontal = "center"
            },
          },
          {
            config = {
              align = "right",
              valign = "middle",
              color = {
                fixed = "text"
              },
              text = {
                field = "by",
                mode = "field"
              },
              size = 20
            },
            background = {
              color = {
                fixed = "transparent"
              },
            },
            placement = {
              top = -84.5,
              height = 50,
              left = -191,
              width = 260
            },
            type = "metric-value",
            constraint = {
              vertical = "center",
              horizontal = "center"
            },
            name = "speaker"
          }
        ],
        background = {
          color = {
            fixed = "transparent"
          },
        },
        name = "container",
        constraint = {
          vertical = "top",
          horizontal = "left"
        },
        placement = {
          width = 100,
          height = 100,
          top = 0,
          left = 0
        }
      }
    },
  }))
}
