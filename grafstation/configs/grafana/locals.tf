locals {
  prometheus = {
    type = grafana_data_source.prometheus.type
    uid  = grafana_data_source.prometheus.uid
  }

  common_base = {
    datasource = local.prometheus,
  }

  stats_base = {
    type    = "stat"
    options = local.basic_stat_options
  }

  basic_stat_options = {
    reduceOptions = {
      values = false
      calcs  = ["last"]
      fields = ""
    }
    orientation = "auto"
    textMode    = "auto"
    colorMode   = "value"
    graphMode   = "none"
    justifyMode = "auto"
    text        = {}
  }

  field_config_base = {
    overrides = []
  }

  field_config_default_base = {
    color = {
      "mode" : "thresholds"
    },
    mappings = [],
    noValue  = "(TBD)",
    unit     = "none"
  }

  thresholds_base = {
    mode = "absolute",
  }

  thresholds_keys = [
    "color", "value"
  ]

  link = {
    asken = {
      links = [{
        targetBlank = true,
        title       = "あすけん",
        url         = "https://www.asken.jp",
      }]
    }
    moneyforward = {
      links = [{
        targetBlank = true,
        title       = "MoneyForward",
        url         = "http://moneyforward.com",
      }]
    }
    openweather = {
      links = [{
        targetBlank = true,
        title       = "OpenWeather",
        url         = "https://openweathermap.org",
      }]
    }
    tado = {
      links = [{
        targetBlank = true,
        title       = "Tado",
        url         = "https://app.tado.com/en/main/home",
      }]
    }
    withings = {
      links = [{
        targetBlank = true,
        title       = "Withings Healthcare",
        url         = "https://healthmate.withings.com/",
      }]
    }
  }

  target_base = {
    datasource   = local.prometheus,
    exemplar     = true,
    format       = "table",
    instant      = false,
    interval     = "",
    legendFormat = "",
    refId        = "A"
  }

  libpanel_keys = ["uid"]
}
