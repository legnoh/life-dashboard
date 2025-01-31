resource "grafana_library_panel" "snmp-in-octets" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.network.uid
  name       = "SNMP - 帯域通信量"
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

resource "grafana_library_panel" "snmp-speedtest-occupancy" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.network.uid
  name       = "SNMP/Speedtest - 帯域利用率"
  model_json = jsonencode(merge(local.common_base, local.stats_base, {
    title = "帯域利用率",
    targets = [
      merge(local.target_base, {
        expr  = "sum(delta(ifInOctets[180s])) * 8 / 180",
        hide  = true,
        refId = "A"
      }),
      merge(local.target_base, {
        expr  = "speedtest_downloadedbytes_bytes{}",
        hide  = true,
        refId = "B"
      }),
      {
        datasource : {
          name : "Expression"
          type : "__expr__"
          uid : "__expr__"
        }
        expression : "$A/$B"
        refId : "C"
        type : "math"
      }
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["green", null]),
            zipmap(local.thresholds_keys, ["yellow", 0.4]),
            zipmap(local.thresholds_keys, ["orange", 0.6]),
            zipmap(local.thresholds_keys, ["red", 0.8]),
          ]
        })
        unit = "percentunit"
      })
    })
  }))
}