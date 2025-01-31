resource "grafana_library_panel" "news-domestic" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.rss.uid
  name       = "news-domestic"
  model_json = jsonencode({
    type = "news",
    options = {
      showImage = false,
      feedUrl   = "http://grafstation.local/news/yahoo/topics/domestic.xml",
    },
  })
}

resource "grafana_library_panel" "news-world" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.rss.uid
  name       = "news-world"
  model_json = jsonencode({
    type = "news",
    options = {
      showImage = false,
      feedUrl   = "http://grafstation.local/news/yahoo/topics/world.xml",
    },
  })
}

resource "grafana_library_panel" "news-business" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.rss.uid
  name       = "news-business"
  model_json = jsonencode({
    type = "news",
    options = {
      showImage = false,
      feedUrl   = "http://grafstation.local/news/yahoo/topics/business.xml",
    },
  })
}

resource "grafana_library_panel" "news-sports" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.rss.uid
  name       = "news-sports"
  model_json = jsonencode({
    type = "news",
    options = {
      showImage = false,
      feedUrl   = "http://grafstation.local/news/yahoo/topics/sports.xml",
    },
  })
}

resource "grafana_library_panel" "news-netkeiba" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.rss.uid
  name       = "news-netkeiba"
  model_json = jsonencode({
    type = "news",
    options = {
      showImage = false,
      feedUrl   = "http://grafstation.local/news/netkeiba?pid=rss_netkeiba&site=netkeiba",
    },
  })
}
