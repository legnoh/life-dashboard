resource "grafana_library_panel" "tv" {
  name = "TV(1ch)"
  model_json = jsonencode({
    type        = "aidanmountford-html-panel",
    transparent = true,
    html_data   = <<-EOT
    <video autoplay controls width="100%" height="100%">
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/m2tsll?mode=0"
        type="application/x-mpegURL"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/webm?mode=0"
        type="video/webm"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/mp4?mode=0"
        type="video/mp4"
      >
      Your browser does not support the video tag.
    </video>
    EOT
  })
}

resource "grafana_library_panel" "tv-muted" {
  name = "TV(1ch/mute)"
  model_json = jsonencode({
    type        = "aidanmountford-html-panel",
    transparent = true,
    html_data   = <<-EOT
    <video autoplay controls muted width="100%" height="100%">
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/m2tsll?mode=0"
        type="application/x-mpegURL"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/webm?mode=0"
        type="video/webm"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID1}/mp4?mode=0"
        type="video/mp4"
      >
      Your browser does not support the video tag.
    </video>
    EOT
  })
}

resource "grafana_library_panel" "tv2" {
  name = "TV(2ch)"
  model_json = jsonencode({
    type        = "aidanmountford-html-panel",
    transparent = true,
    html_data   = <<-EOT
    <video autoplay controls width="100%" height="100%">
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/m2tsll?mode=0"
        type="application/x-mpegURL"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/webm?mode=0"
        type="video/webm"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/mp4?mode=0"
        type="video/mp4"
      >
      Your browser does not support the video tag.
    </video>
    EOT
  })
}

resource "grafana_library_panel" "tv2-muted" {
  name = "TV(2ch/mute)"
  model_json = jsonencode({
    type        = "aidanmountford-html-panel",
    transparent = true,
    html_data   = <<-EOT
    <video autoplay controls muted width="100%" height="100%">
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/m2tsll?mode=0"
        type="application/x-mpegURL"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/webm?mode=0"
        type="video/webm"
      >
      <source
        src="http://${var.TV_EPGSTATION_HOST}/api/streams/live/${var.TV_CHANNEL_ID2}/mp4?mode=0"
        type="video/mp4"
      >
      Your browser does not support the video tag.
    </video>
    EOT
  })
}

