resource "grafana_library_panel" "oura-bmi" {
  org_id = grafana_organization.main.org_id
  name   = "Oura - BMI"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.oura, {
    title = "BMI",
    targets = [merge(local.target_base, {
      expr = "oura_personal_info_weight / (oura_personal_info_height ^ 2)"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["dark-blue", null]),
            zipmap(local.thresholds_keys, ["semi-dark-blue", 16]),
            zipmap(local.thresholds_keys, ["yellow", 17]),
            zipmap(local.thresholds_keys, ["green", 18.5]),
            zipmap(local.thresholds_keys, ["orange", 25]),
            zipmap(local.thresholds_keys, ["red", 30]),
            zipmap(local.thresholds_keys, ["semi-dark-red", 35]),
            zipmap(local.thresholds_keys, ["dark-red", 40]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "oura-readiness-score" {
  org_id = grafana_organization.main.org_id
  name   = "Oura - コンディションスコア"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.oura, {
    title = "コンディションスコア",
    targets = [merge(local.target_base, {
      expr = "oura_daily_readiness_score{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 60]),
            zipmap(local.thresholds_keys, ["yellow", 70]),
            zipmap(local.thresholds_keys, ["green", 85]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "oura-sleep-score" {
  org_id = grafana_organization.main.org_id
  name   = "Oura - 睡眠スコア"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.oura, {
    title = "睡眠スコア",
    targets = [merge(local.target_base, {
      expr = "oura_daily_sleep_score{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 60]),
            zipmap(local.thresholds_keys, ["yellow", 70]),
            zipmap(local.thresholds_keys, ["green", 85]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "oura-activity-score" {
  org_id = grafana_organization.main.org_id
  name   = "Oura - アクティビティスコア"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.oura, {
    title = "アクティビティスコア",
    targets = [merge(local.target_base, {
      expr = "oura_daily_activity_score{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 60]),
            zipmap(local.thresholds_keys, ["yellow", 70]),
            zipmap(local.thresholds_keys, ["green", 85]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "oura-steps" {
  org_id = grafana_organization.main.org_id
  name   = "Oura - 歩数"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.oura, {
    title = "歩数",
    targets = [merge(local.target_base, {
      expr = "oura_daily_activity_steps{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["light-red", 1000]),
            zipmap(local.thresholds_keys, ["light-orange", 4000]),
            zipmap(local.thresholds_keys, ["orange", 5000]),
            zipmap(local.thresholds_keys, ["light-green", 7500]),
            zipmap(local.thresholds_keys, ["green", 10000]),
          ]
        })
        unit = "歩"
      })
    })
  }))
}
