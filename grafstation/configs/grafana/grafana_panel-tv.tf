locals {
  stream_urls = {
    daymode-bgm = {
      name = "LIVE STREAM - Cafe Music BGM channel"
      url  = "https://www.youtube.com/embed/videoseries?autoplay=1&list=PLYyJCobshLZkNKdbhWzRMhtqe0S6shnB1"
    }
    nightmode-bgm = {
      name = "TOKYO Cafe: Night Coffee Shop Ambience - Cafe Music BGM channel"
      url  = "https://www.youtube.com/embed/6uddGul0oAc?autoplay=1"
    }
    sleep-bgm = {
      name = "睡眠導入用BGM"
      url  = "https://www.youtube.com/embed/UtO59mdkF7I?autoplay=1"
    }
    stretch = {
      name = "施術のプロが考案！ 1回3分でできる「痩せるスゴレッチ」"
      url  = "https://www.youtube.com/embed/5haAgY-JxcA?autoplay=1&start=299"
    }
    fitness = {
      name = "筋トレ用プレイリスト"
      url  = "https://www.youtube.com/embed/videoseries?autoplay=1&list=PLBdI4smwsafofooNhNuBsJHqdQ57-c-xo"
    }
    news-domestic = {
      name = "JapaNews24 ～日本のニュースを24時間配信"
      url  = "https://www.youtube.com/embed/coYw-eVU0Ks?autoplay=1"
    }
    news-global = {
      name = "ABC World News Tonight Full Broadcast"
      url  = "https://www.youtube.com/embed/videoseries?autoplay=1&list=PLQOa26lW-uI8ixlVw1NWu_l4Eh8iZW_qN"
    }
    vtuber = {
      name = "VTuber(2434) Live Playlist"
      url  = "http://grafstation.local/player/youtube.html?list=${var.YOUTUBE_PLAYLIST_ID}"
    }
    mahjong = {
      name = "Mリーグ"
      url  = "http://grafstation.local/player/hls.html?url=http%3A%2F%2Fgrafstation.local%2Fstream%2Fstream.m3u8"
    }
    greench = {
      name = "GREEN Ch."
      url  = "http://grafstation.local/player/hls.html?url=${local.gch_stream_url_encode}"
    }
    earthquake = {
      name = "地震速報"
      url  = "https://www.youtube.com/embed/HXGANE2pRrA?autoplay=1"
    }
  }

  gch_stream_url_encode = urlencode(var.GCH_STREAM_URL)

  tv_channel1     = lookup(local.stream_urls, var.TV_CHANNEL1, local.stream_urls.nightmode-bgm)
  tv_channel1_url = var.IS_TV_CHANNEL1_MUTED ? format("%s&mute=1", local.tv_channel1.url) : local.tv_channel1.url
  tv_channel2     = lookup(local.stream_urls, var.TV_CHANNEL2, local.stream_urls.vtuber)
  tv_channel2_url = var.IS_TV_CHANNEL2_MUTED ? format("%s&mute=1", local.tv_channel2.url) : local.tv_channel2.url
}

resource "grafana_library_panel" "channel1" {
  org_id = grafana_organization.main.org_id
  name   = local.tv_channel1.name
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = local.tv_channel1_url,
    },
  })
}

resource "grafana_library_panel" "channel2" {
  org_id = grafana_organization.main.org_id
  name   = local.tv_channel2.name
  model_json = jsonencode({
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = local.tv_channel2_url,
    },
  })
}
