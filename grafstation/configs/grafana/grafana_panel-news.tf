resource "grafana_library_panel" "news-domestic" {
  name = "news-domestic"
  model_json = jsonencode({
    type        = "news",
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/domestic.xml",
    },
  })
}

resource "grafana_library_panel" "news-world" {
  name = "news-world"
  model_json = jsonencode({
    type        = "news",
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/world.xml",
    },
  })
}

resource "grafana_library_panel" "news-business" {
  name = "news-business"
  model_json = jsonencode({
    type        = "news",
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/business.xml",
    },
  })
}

resource "grafana_library_panel" "news-sports" {
  name = "news-sports"
  model_json = jsonencode({
    type        = "news",
    options = {
      showImage  = false,
      feedUrl = "http://grafstation.local/news/yahoo/sports.xml",
    },
  })
}
