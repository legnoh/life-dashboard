variable "GRAFANA_HOST" {
  type = string
  default = "localhost:3000"
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

variable "IS_DAYMODE" {
  type = bool
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
