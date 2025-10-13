# resource "grafana_library_panel" "calendar" {
#   org_id     = grafana_organization.main.org_id
#   folder_uid = grafana_folder.etc.uid
#   name       = "予定"
#   model_json = jsonencode(merge(local.common_base, local.table_base, {
#     title = "BMI",
#     targets = [merge(local.target_base, {
#       expr = "withings_meas_weight / (1.645 ^ 2)"
#     })]
#     fieldConfig = merge(local.field_config_base, {
#       defaults = merge(local.field_config_default_base, {
#         thresholds = merge(local.thresholds_base, {
#           steps = [
#             zipmap(local.thresholds_keys, ["dark-blue", null]),
#             zipmap(local.thresholds_keys, ["semi-dark-blue", 16]),
#             zipmap(local.thresholds_keys, ["yellow", 17]),
#             zipmap(local.thresholds_keys, ["green", 18.5]),
#             zipmap(local.thresholds_keys, ["orange", 25]),
#             zipmap(local.thresholds_keys, ["red", 30]),
#             zipmap(local.thresholds_keys, ["semi-dark-red", 35]),
#             zipmap(local.thresholds_keys, ["dark-red", 40]),
#           ]
#         })
#       })
#     })
#   }))
# }
