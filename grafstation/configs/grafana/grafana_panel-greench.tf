locals {
  gch_stream_url_encode = urlencode( var.GCH_STREAM_URL )
}

resource "grafana_library_panel" "greench" {
  org_id = grafana_organization.main.org_id
  name = "GREEN ch."
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/general.html?url=${local.gch_stream_url_encode}",
    },
  })
}

resource "grafana_library_panel" "greench_muted" {
  org_id = grafana_organization.main.org_id
  name = "GREEN ch.(muted)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/general.html?url=${local.gch_stream_url_encode}&muted=true",
    },
  })
}
