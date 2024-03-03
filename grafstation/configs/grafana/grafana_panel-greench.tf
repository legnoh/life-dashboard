resource "grafana_library_panel" "greench" {
  org_id = grafana_organization.main.org_id
  name = "GREEN ch."
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "${var.GCH_STREAM_URL}",
    },
  })
}
