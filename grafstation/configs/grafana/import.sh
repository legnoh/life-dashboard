#!/opt/homebrew/bin/bash

set -x

JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"

GRAFANA_HOST=${GRAFANA_HOST:-"hal-mini.local:3000"}

tf_resource_names=(
  grafana_data_source
  # grafana_library_panel
  # grafana_dashboard
  # grafana_folder
)

tf_resource_api_path=(
  datasources
  library-elements
  search?type=dash-db
  folders
)

tf_resource_grafana_data_sources=(
  Prometheus
)

tf_resource_grafana_library_panels=(
  asken-score
  clock
  moneyforward-balancesheet
  moneyforward-balance
  moneyforward-deposit-withdrawal
  openweather-temperature
  openweather-humidity
  openweather-condition
  smartmeter-power-consumption
  snmp-in-octets
  speedtest-score
  tado-temperature
  tado-humidity
  todoist-tasknum
  tv
  tv-muted
  tv2
  tv2-muted
  withings-bmi
  withings-fat-ratio
  withings-bpm-max
  withings-bpm-min
  withings-steps
  withings-sleep-score
  youtube
  youtube-muted
  youtube-nightmode-muted
)

tf_resource_grafana_dashboards=(
  life-metrics
)

tf_resource_grafana_folders=(
  service
)


len=$(echo "${#tf_resource_names[@]} - 1" | bc)
for i in $(seq 0 ${len})
do
  resource_type=${tf_resource_names[$i]}
  resource_api_path=${tf_resource_api_path[$i]}

  grafana_now_states=$(curl "http://${GRAFANA_HOST}/api/${resource_api_path}" 2>/dev/null)

  resources="tf_resource_${resource_type}s"
  for resource_name in ${!resources}
  do
    uid=$(echo ${grafana_now_states} | ${JQ} -r ".[] | select(.name==\"${resource_name}\") | .uid")
    ${TF} import ${resource_type}.${resource_name} ${uid}
  done
done
