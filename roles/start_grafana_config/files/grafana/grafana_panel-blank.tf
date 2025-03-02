resource "grafana_library_panel" "blank" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.etc.uid
  name       = "空白"
  model_json = jsonencode({
    title = ""
    type  = "text"
    options = {
      mode = "markdown"
      code = {
        language = "plaintext"
      }
      content = ""
    }
  })
}
