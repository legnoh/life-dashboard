resource "grafana_library_panel" "streamlink" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstreamlink",
    },
  })
}

resource "grafana_library_panel" "streamlink-muted" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink(muted)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstreamlink&muted=1",
    },
  })
}
