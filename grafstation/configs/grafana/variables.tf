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

variable "IS_YOUTUBE_MUTED" {
  type    = bool
  default = true
}

variable "GCH_STREAM_URL" {
  type    = string
  default = ""
}

variable "NATURE_REMO_DEVICE_NAME" {
  type    = string
  default = "Nature Remo"
}

variable "OPENWEATHER_CITY" {
  type    = string
  default = "Tokyo, JP"
}

variable "IS_DAYMODE" {
  type    = bool
  default = false
}

variable "IS_NEWSTIME_DOMESTIC" {
  type    = bool
  default = false
}

variable "IS_NEWSTIME_GLOBAL" {
  type    = bool
  default = false
}

variable "IS_RACETIME" {
  type    = bool
  default = false
}

variable "IS_REFRESHTIME" {
  type    = bool
  default = false
}

variable "IS_STREAM_ONAIR" {
  type    = bool
  default = false
}

variable "IS_EARTHQUAKE" {
  type    = bool
  default = false
}
