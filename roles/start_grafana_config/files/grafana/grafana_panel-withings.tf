resource "grafana_library_panel" "withings-bmi" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - BMI"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "BMI",
    targets = [merge(local.target_base, {
      expr = "withings_meas_weight / (1.645 ^ 2)"
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

resource "grafana_library_panel" "withings-fat-ratio" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - 体脂肪率"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "体脂肪率",
    targets = [merge(local.target_base, {
      expr = "withings_meas_fat_ratio{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["green", null]),
            zipmap(local.thresholds_keys, ["yellow", 20]),
            zipmap(local.thresholds_keys, ["orange", 25]),
            zipmap(local.thresholds_keys, ["red", 30]),
          ]
        })
        unit = "percent"
      })
    })
  }))
}

resource "grafana_library_panel" "withings-bpm-max" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - 最高血圧(mmHg)"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "最高血圧",
    targets = [merge(local.target_base, {
      expr = "withings_meas_systolic_blood_pressure{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["green", null]),
            zipmap(local.thresholds_keys, ["light-green", 120]),
            zipmap(local.thresholds_keys, ["yellow", 130]),
            zipmap(local.thresholds_keys, ["orange", 140]),
            zipmap(local.thresholds_keys, ["semi-dark-orange", 160]),
            zipmap(local.thresholds_keys, ["red", 180]),
          ]
        })
      })
    })
  }))
}

resource "grafana_library_panel" "withings-body-temperature" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - 体温"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "体温",
    targets = [merge(local.target_base, {
      expr = "withings_meas_body_temperature{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["blue", null]),
            zipmap(local.thresholds_keys, ["light-green", 35.5]),
            zipmap(local.thresholds_keys, ["yellow", 37]),
            zipmap(local.thresholds_keys, ["orange", 38]),
            zipmap(local.thresholds_keys, ["semi-dark-orange", 39]),
            zipmap(local.thresholds_keys, ["red", 40]),
          ]
        })
        unit = "celsius"
      })
    })
  }))
}

resource "grafana_library_panel" "withings-steps" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - 歩数"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "歩数",
    targets = [merge(local.target_base, {
      expr = "withings_activity_steps{}"
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

resource "grafana_library_panel" "withings-sleep-score" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.healthcare.uid
  name       = "Withings - 睡眠スコア"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.withings, {
    title = "睡眠スコア",
    targets = [merge(local.target_base, {
      expr = "withings_sleep_sleep_score{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 50]),
            zipmap(local.thresholds_keys, ["green", 75]),
          ]
        })
      })
    })
  }))
}
