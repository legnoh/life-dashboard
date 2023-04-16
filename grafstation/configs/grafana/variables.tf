variable "GRAFANA_HOST" {
  type = string
  default = "localhost:3000"
}

variable "TV_EPGSTATION_HOST" {
  type = string
  default = "localhost:8888"
}

variable "TV_CHANNEL_ID1" {
  type    = string
  default = ""
}

variable "TV_CHANNEL_ID2" {
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
}

variable "IS_YOUTUBE_MUTED" {
  type    = bool
  default = true
}

variable "TADO_ZONE_NAME" {
  type    = string
  default = "Air Conditioning"
}

variable "OPENWEATHER_CITY" {
  type    = string
  default = "Tokyo, JP"
}
