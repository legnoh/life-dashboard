resource "grafana_library_panel" "snmp-in-octets" {
  org_id = grafana_organization.main.org_id
  name = "SNMP - 帯域通信量"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "帯域通信量",
    targets = [merge(local.target_base, {
      expr = "sum(delta(ifInOctets[180s])) * 8 / 180"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["green", null]),
            zipmap(local.thresholds_keys, ["light-green", 10000000]),
            zipmap(local.thresholds_keys, ["light-yellow", 5000000]),
            zipmap(local.thresholds_keys, ["yellow", 10000000]),
            zipmap(local.thresholds_keys, ["light-orange", 30000000]),
            zipmap(local.thresholds_keys, ["super-light-orange", 50000000]),
            zipmap(local.thresholds_keys, ["light-green", 100000000]),
            zipmap(local.thresholds_keys, ["green", 300000000]),
            zipmap(local.thresholds_keys, ["semi-dark-green", 500000000]),
            zipmap(local.thresholds_keys, ["dark-green", 1000000000]),
          ]
        })
        unit = "bps"
      })
    })
  }))
}
