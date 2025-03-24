variable "GRAFANA_HOST" {
  type    = string
  default = "localhost:3000"
}

variable "TV_CHANNEL1" {
  type    = string
  default = "daymode-bgm"
  validation {
    condition     = contains(["daymode-bgm", "nightmode-bgm", "sleep-bgm", "stretch", "fitness", "news-domestic", "news-global", "vtuber", "mahjong", "greench", "earthquake"], var.TV_CHANNEL1)
    error_message = "This value is not permitted in condition!"
  }
}

variable "TV_CHANNEL2" {
  type    = string
  default = "vtuber"
  validation {
    condition     = contains(["daymode-bgm", "nightmode-bgm", "sleep-bgm", "stretch", "fitness", "news-domestic", "news-global", "vtuber", "mahjong", "greench", "earthquake"], var.TV_CHANNEL2)
    error_message = "This value is not permitted in condition!"
  }
}

variable "IS_TV_CHANNEL1_MUTED" {
  type    = bool
  default = false
}

variable "IS_TV_CHANNEL2_MUTED" {
  type    = bool
  default = true
}

variable "YOUTUBE_PLAYLIST_ID" {
  type    = string
  default = ""
}

variable "GCH_STREAMS" {
  type = list(object({
    channel_id   = string
    program_name = string
    stream_url   = string
  }))
  default = [
    {
      channel_id   = "ch1"
      program_name = "dummy"
      stream_url   = "https://example.com"
    },
  ]
}

variable "NATURE_REMO_DEVICE_NAME" {
  type    = string
  default = "Nature Remo"
}

variable "OPENWEATHER_CITY" {
  type    = string
  default = "Tokyo, JP"
}
