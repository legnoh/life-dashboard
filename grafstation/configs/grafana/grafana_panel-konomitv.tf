resource "grafana_library_panel" "konomitv" {
  org_id = grafana_organization.main.org_id
  name = "KonomiTV(1ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/konomitv.html?channel=${var.TV_CHANNEL1_ID}",
    },
  })
}

resource "grafana_library_panel" "konomitv-muted" {
  org_id = grafana_organization.main.org_id
  name = "KonomiTV(1ch/mute)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/konomitv.html?channel=${var.TV_CHANNEL1_ID}&muted=true",
    },
  })
}

resource "grafana_library_panel" "konomitv2" {
  org_id = grafana_organization.main.org_id
  name = "KonomiTV(2ch)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/konomitv.html?channel=${var.TV_CHANNEL2_ID}",
    },
  })
}

resource "grafana_library_panel" "konomitv2-muted" {
  org_id = grafana_organization.main.org_id
  name = "KonomiTV(2ch/mute)"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/konomitv.html?channel=${var.TV_CHANNEL2_ID}&muted=true",
    },
  })
}
