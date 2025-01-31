resource "grafana_library_panel" "channel1" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.onair.uid
  name       = local.tv_channel1.name
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = local.tv_channel1_url,
    },
  })
}

resource "grafana_library_panel" "channel2" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.onair.uid
  name       = local.tv_channel2.name
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = local.tv_channel2_url,
    },
  })
}
