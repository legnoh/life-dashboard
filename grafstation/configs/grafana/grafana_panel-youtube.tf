resource "grafana_library_panel" "youtube" {
  org_id = grafana_organization.main.org_id
  name = "youtube"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/youtube.html?list=${var.YOUTUBE_PLAYLIST_ID}",
    },
  })
}

resource "grafana_library_panel" "youtube-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/youtube.html?list=${var.YOUTUBE_PLAYLIST_ID}&muted=true",
    },
  })
}

# resource "grafana_library_panel" "youtube-daymode-muted" {
#   org_id = grafana_organization.main.org_id
#   name = "youtube-daymode-muted"
#   model_json = jsonencode({
#     type        = "innius-video-panel",
#     transparent = true,
#     options = {
#       autoPlay  = true,
#       videoType = "iframe",
#       iframeURL = "https://www.youtube.com/embed/Q-sZipetAEc?mute=1&autoplay=1&loop=1&playsinline=1",
#     },
#   })
# }

resource "grafana_library_panel" "youtube-nightmode-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-nightmode-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/Q-sZipetAEc?mute=1&autoplay=1&loop=1&playsinline=1",
    },
  })
}
