resource "grafana_library_panel" "moneyforward-balancesheet" {
  org_id = grafana_organization.main.org_id
  name = "moneyforward-balancesheet"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.moneyforward, {
    title = "バランスシート",
    targets = [merge(local.target_base, {
      expr = "mf_assets_total_jpy - ignoring(type) mf_assets_subtotal_jpy{type=\"年金\"} - (mf_liability_total_jpy - ignoring(type) mf_liability_subtotal_jpy{type=\"奨学金\"})"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["dark-red", null]),
            zipmap(local.thresholds_keys, ["semi-dark-red", -1000000]),
            zipmap(local.thresholds_keys, ["dark-yellow", 0]),
            zipmap(local.thresholds_keys, ["yellow", 100000]),
            zipmap(local.thresholds_keys, ["light-green", 300000]),
            zipmap(local.thresholds_keys, ["green", 600000]),
          ]
        })
        unit = "currencyJPY"
      })
    })
  }))
}

resource "grafana_library_panel" "moneyforward-balance" {
  org_id = grafana_organization.main.org_id
  name = "moneyforward-balance"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.moneyforward, {
    title = "当月収支",
    targets = [merge(local.target_base, {
      expr = "mf_monthly_balance_jpy{}"
    })]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["red", null]),
            zipmap(local.thresholds_keys, ["orange", 0]),
            zipmap(local.thresholds_keys, ["light-orange", 30000]),
            zipmap(local.thresholds_keys, ["yellow", 50000]),
            zipmap(local.thresholds_keys, ["light-green", 70000]),
            zipmap(local.thresholds_keys, ["green", 100000]),
          ]
        })
        unit = "currencyJPY"
      })
    })
  }))
}

resource "grafana_library_panel" "moneyforward-deposit-withdrawal" {
  org_id = grafana_organization.main.org_id
  name = "moneyforward-deposit-withdrawal"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.moneyforward, {
    title = "残高足りる?",
    targets = [
      merge(local.target_base, {
        expr = "mf_assets_deposit_jpy{account=\"住信SBIネット銀行\",name=\"代表口座 - 円普通\"}"
        hide: true
        refId: "A"
      }),
      merge(local.target_base, {
        expr = "mf_monthly_withdrawal_jpy{name=~\".*カード\"}"
        hide: true
        refId: "B"
      }),
      {
        datasource: {
          name: "Expression"
          type: "__expr__"
          uid: "__expr__"
        }
        expression: "$A + $B"
        refId: "C"
        type: "math"
      }
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["text", null]),
            zipmap(local.thresholds_keys, ["dark-red", -1000000]),
            zipmap(local.thresholds_keys, ["semi-dark-red", 0]),
            zipmap(local.thresholds_keys, ["red", 20000]),
            zipmap(local.thresholds_keys, ["light-green", 50000]),
            zipmap(local.thresholds_keys, ["green", 100000]),
          ]
        })
        unit = "currencyJPY"
      })
    })
  }))
}
