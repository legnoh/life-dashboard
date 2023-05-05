resource "grafana_library_panel" "news" {
  name = "news"
  model_json = jsonencode({
    type        = "news",
    transparent = true,
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/top-picks.xml",
    },
  })
}
