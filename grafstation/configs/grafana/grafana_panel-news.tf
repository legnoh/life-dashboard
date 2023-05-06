resource "grafana_library_panel" "news-domestic" {
  name = "news"
  model_json = jsonencode({
    type        = "news",
    transparent = true,
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/domestic.xml",
    },
  })
}

resource "grafana_library_panel" "news-world" {
  name = "news"
  model_json = jsonencode({
    type        = "news",
    transparent = true,
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/world.xml",
    },
  })
}

resource "grafana_library_panel" "news-business" {
  name = "news"
  model_json = jsonencode({
    type        = "news",
    transparent = true,
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/business.xml",
    },
  })
}

resource "grafana_library_panel" "news-sports" {
  name = "news"
  model_json = jsonencode({
    type        = "news",
    transparent = true,
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/sports.xml",
    },
  })
}
