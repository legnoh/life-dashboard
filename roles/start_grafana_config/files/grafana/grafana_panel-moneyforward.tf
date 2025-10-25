resource "grafana_library_panel" "moneyforward-balancesheet" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.finance.uid
  name       = "moneyforward-balancesheet"
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
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.finance.uid
  name       = "moneyforward-balance"
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
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.finance.uid
  name       = "moneyforward-deposit-withdrawal"
  model_json = jsonencode(merge(local.common_base, local.stats_base, local.link.moneyforward, {
    title = "残高足りる?",
    targets = [
      merge(local.target_base, {
        expr = "mf_assets_deposit_jpy{account=\"住信SBIネット銀行\",name=\"代表口座 - 円普通\"}"
        hide : true
        refId : "A"
      }),
      merge(local.target_base, {
        expr = "sum(mf_monthly_withdrawal_jpy{name=~\".*カード\"} * on() group_left() (day_of_month() >= bool 24) * on() group_left() (day_of_month() <= bool 27))"
        hide : true
        refId : "B"
      }),
      merge(local.target_base, {
        expr = "sum(scholarship_next_repayment_amount_jpy * on() group_left() (day_of_month() >= bool 24) * on() group_left() (day_of_month() <= bool 27)) * -1"
        hide : true
        refId : "C"
      }),
      merge(local.target_base, {
        expr = "(  (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 2000)    * mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"}+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 2000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 100000)) * 2000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 100000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 200000)) * 4000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 200000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 400000)) * 6000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 400000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 600000)) * 8000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 600000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 800000)) * 11000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 800000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 1000000)) * 15000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 1000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 1500000)) * 20000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 1500000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 3000000)) * 25000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 3000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 4000000)) * 30000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 4000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 5000000)) * 40000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 5000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 6000000)) * 50000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 6000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 7000000)) * 60000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 7000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 8000000)) * 70000+ ((mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 8000000)   * (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} <= bool 9000000)) * 75000+  (mf_liability_detail_jpy{account=\"住信SBIネット銀行\",name=\"ローン(カードローン)\"} > bool 9000000) * 80000) * on() group_left() (day_of_month() >= bool 1) * on() group_left() (day_of_month() <= bool 5) * -1"
        hide : true
        refId : "D"
      }),
      {
        datasource : {
          name : "Expression"
          type : "__expr__"
          uid : "__expr__"
        }
        expression : "$A + $B + $C + $D"
        refId : "E"
        type : "math"
      }
    ]
    fieldConfig = merge(local.field_config_base, {
      defaults = merge(local.field_config_default_base, {
        thresholds = merge(local.thresholds_base, {
          steps = [
            zipmap(local.thresholds_keys, ["#181b1f", null]),
            zipmap(local.thresholds_keys, ["red", -1000000]),
            zipmap(local.thresholds_keys, ["orange", 0]),
            zipmap(local.thresholds_keys, ["yellow", 20000]),
            zipmap(local.thresholds_keys, ["light-green", 50000]),
            zipmap(local.thresholds_keys, ["green", 100000]),
          ]
        })
        unit = "currencyJPY"
      })
    })
  }))
}
