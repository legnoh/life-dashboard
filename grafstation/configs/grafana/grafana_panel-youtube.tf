resource "grafana_library_panel" "youtube" {
  name = "youtube"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed?mute=0&autoplay=1&listType=playlist&loop=1&playsinline=1&list=${var.YOUTUBE_PLAYLIST_ID}",
    },
  })
}

resource "grafana_library_panel" "youtube-muted" {
  name = "youtube-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed?mute=1&autoplay=1&listType=playlist&loop=1&playsinline=1&list=${var.YOUTUBE_PLAYLIST_ID}",
    },
  })
}

# resource "grafana_library_panel" "youtube-daymode-muted" {
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
