resource "grafana_library_panel" "youtube-vtuber" {
  org_id = grafana_organization.main.org_id
  name = "youtube-vtuber"
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

resource "grafana_library_panel" "youtube-vtuber-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-vtuber-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/youtube.html?list=${var.YOUTUBE_PLAYLIST_ID}&mute=1",
    },
  })
}

resource "grafana_library_panel" "youtube-daymode-bgm" {
  org_id = grafana_organization.main.org_id
  name = "youtube-daymode-bgm"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/videoseries?autoplay=1&loop=1&list=PLYyJCobshLZkNKdbhWzRMhtqe0S6shnB1",
    },
  })
}

resource "grafana_library_panel" "youtube-nightmode-bgm" {
  org_id = grafana_organization.main.org_id
  name = "youtube-nightmode-bgm"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/6uddGul0oAc?autoplay=1&loop=1&playsinline=1",
    },
  })
}

resource "grafana_library_panel" "youtube-daymode-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-daymode-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/videoseries?mute=1&autoplay=1&loop=1&list=PLYyJCobshLZkNKdbhWzRMhtqe0S6shnB1",
    },
  })
}

resource "grafana_library_panel" "youtube-nightmode-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-nightmode-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/6uddGul0oAc?mute=1&autoplay=1&loop=1&playsinline=1",
    },
  })
}

resource "grafana_library_panel" "youtube-stretch" {
  org_id = grafana_organization.main.org_id
  name = "youtube-stretch"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/5haAgY-JxcA?autoplay=1&start=299",
    },
  })
}

resource "grafana_library_panel" "youtube-stretch-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-stretch-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/5haAgY-JxcA?mute=1autoplay=1&start=299",
    },
  })
}

resource "grafana_library_panel" "youtube-news-domestic" {
  org_id = grafana_organization.main.org_id
  name = "youtube-news-domestic"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/coYw-eVU0Ks?autoplay=1&loop=1&playsinline=1",
    },
  })
}

resource "grafana_library_panel" "youtube-news-domestic-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-news-domestic-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/coYw-eVU0Ks?mute=1&autoplay=1&loop=1&playsinline=1",
    },
  })
}

resource "grafana_library_panel" "youtube-news-global" {
  org_id = grafana_organization.main.org_id
  name = "youtube-news-global"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/videoseries?autoplay=1&loop=1&cc_lang_pref=eng&cc_load_policy=1&list=PLQOa26lW-uI8ixlVw1NWu_l4Eh8iZW_qN",
    },
  })
}

resource "grafana_library_panel" "youtube-news-global-muted" {
  org_id = grafana_organization.main.org_id
  name = "youtube-news-global-muted"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/videoseries?mute=1&autoplay=1&loop=1&cc_lang_pref=eng&cc_load_policy=1&list=PLQOa26lW-uI8ixlVw1NWu_l4Eh8iZW_qN",
    },
  })
}

resource "grafana_library_panel" "youtube-earthquake" {
  org_id = grafana_organization.main.org_id
  name = "youtube-earthquake"
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "https://www.youtube.com/embed/HXGANE2pRrA?autoplay=1&loop=1",
    },
  })
}
