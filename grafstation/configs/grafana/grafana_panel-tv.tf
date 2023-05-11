resource "grafana_library_panel" "tv" {
  name = "TV(1ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://${var.TV_EPGSTATION_HOST}/player/mpegts.html?channel=${var.TV_CHANNEL_ID1}",
    },
  })
}

resource "grafana_library_panel" "tv-muted" {
  name = "TV(1ch/mute)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://${var.TV_EPGSTATION_HOST}/player/mpegts.html?channel=${var.TV_CHANNEL_ID1}&muted=true",
    },
  })
}

resource "grafana_library_panel" "tv2" {
  name = "TV(2ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://${var.TV_EPGSTATION_HOST}/player/mpegts.html?channel=${var.TV_CHANNEL_ID2}",
    },
  })
}

resource "grafana_library_panel" "tv2-muted" {
  name = "TV(2ch/mute)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://${var.TV_EPGSTATION_HOST}/player/mpegts.html?channel=${var.TV_CHANNEL_ID2}&muted=true",
    },
  })
}
