variable "GRAFANA_HOST" {
  type = string
  default = "localhost:3000"
}

variable "IS_DAYMODE" {
  type = bool
  default = false
}

variable "TV_EPGSTATION_HOST" {
  type = string
  default = "grafstation.local:8888"
}

variable "TV_CHANNEL1_ID" {
  type    = string
  default = ""
}

variable "TV_CHANNEL2_ID" {
  type    = string
  default = ""
}

variable "IS_TV_CHANNEL1_MUTED" {
  type    = bool
  default = true
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

variable "IS_RACETIME" {
  type    = bool
  default = false
}

variable "IS_REFRESHTIME" {
  type    = bool
  default = false
}

variable "IS_REFRESHTIME_SHUFFLE" {
  type    = bool
  default = false
}
