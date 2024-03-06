resource "grafana_library_panel" "stream1" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink(1ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstream%2F1",
    },
  })
}

resource "grafana_library_panel" "stream1-muted" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink(1ch/muted)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstream%2F1&muted=true",
    },
  })
}

resource "grafana_library_panel" "stream2" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink(2ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstream%2F2",
    },
  })
}

resource "grafana_library_panel" "stream2-muted" {
  org_id = grafana_organization.main.org_id
  name = "Streamlink(2ch/muted)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/mpegts.html?url=http%3A%2F%2Fgrafstation.local%2Fstream%2F2&muted=true",
    },
  })
}
