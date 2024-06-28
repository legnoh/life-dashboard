#!/opt/homebrew/bin/bash

# set -x

TIMESTAMP=$(date "+%s")

JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"
BREW="/opt/homebrew/bin/brew"

ABEMA_JWT_TOKEN=${ABEMA_JWT_TOKEN:-""}

DND_JSON_FILE="${HOME}/Library/DoNotDisturb/DB/Assertions.json"
ABEMA_SLOTS_FILE="/tmp/abema_slots.json"
DIRT_RACE_JSON="/tmp/dirt_races.json"
GCH_ONAIR_JSON="/tmp/gch_onair.json"
STREAM_START_FILE="/tmp/start.stream"

MODE_MEAL="食事"
MODE_WORKOUT="フィットネス"
MODE_STRETCH="ストレッチ"
MODE_PRESLEEP="睡眠導入"
MODE_SLEEP="睡眠"

TFVARS=(
  tv_channel1
  tv_channel2
  is_tv_channel1_muted
  is_tv_channel2_muted
)
TF_OPTIONS=${TERRAFORM_OPTIONS:-"-auto-approve -var-file=/tmp/gchls.tfvars"}

# ABEMAの番組表をバックアップする
function fetch_abema_slots_data() {
  local token=${1:?}
  local timetable_url="https://api.p-c3-e.abema-tv.com/v1/timetable/dataSet?debug=false"

  if [[ ! -e "${ABEMA_SLOTS_FILE}" ]] || [[ $(date "+%M") == "00" ]]; then
    local onair_slot=$(curl -o - -q -L \
      -H "Accept-Encoding: gzip" \
      -H "Authorization: Bearer ${token}" "${timetable_url}" \
      | gunzip)
    echo ${onair_slot} > ${ABEMA_SLOTS_FILE}
  fi
}

# 中央競馬中継放送情報を取得する
function fetch_gch_onair_data() {
  local ymd=$(date "+%Y%m%d")
  local url="https://sp.gch.jp/api_epg/?channel_code=ch1&date_from=${ymd}&date_to=${ymd}"

  if [[ ! -e "${GCH_ONAIR_JSON}" ]] || [[ $(date "+%M") == "00" ]]; then
    curl -s -o "${GCH_ONAIR_JSON}" "${url}"
  fi
}

# ダートレース情報を取得する
function fetch_dirt_race_data() {
  local json_url="https://jra.event.lkj.io/graderaces_dirtgrade.json"

  if [[ ! -e "${DIRT_RACE_JSON}" ]] || [[ $(date "+%M") == "00" ]]; then
    curl -s -o "${DIRT_RACE_JSON}" "${json_url}"
  fi
}

# Mリーグをやっているか確認する
function is_mleague_onair() {

  local now_unixtime=${TIMESTAMP}
  local filepath=${ABEMA_SLOTS_FILE}

  local mleague_onair_slot=$(cat ${filepath} \
    | ${JQ} -r ".slots[] \
      | select( .channelId == \"mahjong\" and .mark.live == true ) \
      | select(.title | contains(\"Mリーグ\") ) \
      | select(.startAt < ${now_unixtime} and .endAt > ${now_unixtime} ) \
      | .id")
    if [[ ${mleague_onair_slot} != "" ]]; then
      return 0
    else
      return 1
    fi
}

# ストリームの開始時間を確認し、5時間以上経過していたら再起動する
function restart_stream(){
  local mleague_url="https://abema.tv/now-on-air/mahjong"

  if [[ ! -e "${STREAM_START_FILE}" ]]; then
    echo "ストリームを再起動します(ファイルなし)"
    cd ../stream && ./start.sh "${mleague_url}" && cd -
    return 0
  fi

  local now_unixtime=${TIMESTAMP}
  local stream_start_unixtime=$(date -r ${STREAM_START_FILE} +%s)
  local elapsed_time=$(( ${now_unixtime} - ${stream_start_unixtime} ))
  if (( ${elapsed_time} > 18000 )); then
    echo "ストリームを再起動します(5時間経過)"
    cd ../stream && ./start.sh "${mleague_url}" && cd -

    # キャッシュクリアのため、grafana-kioskも再起動する
    ${BREW} services restart grafana-kiosk
  fi
}

# 中央競馬の中継中か確認する
function is_national_racetime(){
  local ts=$(date +%s)
  local num=0

  num=$(cat ${GCH_ONAIR_JSON} \
    | ${JQ} -r "[ .[][] \
      | select(.category_name==\"中継\") \
      | select(.program_name | contains(\"中央競馬\")) \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber) \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) \
      | select( .live_start_datetime < ${ts} and .live_end_datetime > ${ts} ) ] | length" \
  )

  if [[ "${num}" == "" ]]; then
    num=0
  fi
  if [[ ${num} > 0 ]]; then
    return 0
  else
    return 1
  fi
}

# ダートグレード競走をやっているか確認する
function is_dirt_grade_race() {
  local num=0

  num=$(cat ${DIRT_RACE_JSON} \
    | ${JQ} -r "[.races[] | select(.start_at - ${TIMESTAMP} < 3600 and .end_at + 900 > ${TIMESTAMP})] | length"
  )

  if [[ "${num}" == "" ]]; then
      num=0
    fi
    if [[ ${num} > 0 ]]; then
      return 0
    else
      return 1
    fi
}

# 地震がなかったか確認する
# https://www.p2pquake.net/develop/
function check_latest_earthquake() {
  echo $(curl -s "https://api.p2pquake.net/v2/history?codes=556&limit=1" \
    | ${JQ} -r ".[].time \
      | split(\".\")[0] \
      | strptime(\"%Y/%m/%d %H:%M:%S\") \
      | strftime(\"%s\")" \
  )
}

function main(){

  echo "---------------------------------"
  date "+%Y/%m/%d %H:%M:%S"

  # 外部データ取得処理
  fetch_abema_slots_data "${ABEMA_JWT_TOKEN}"
  fetch_gch_onair_data
  fetch_dirt_race_data

  # 曜日・時間を取得
  weekday=$(date +%u) # 月-日 = 1-7
  hour=$(date +%-H)
  min=$(date +%-M)
  now=$(echo "scale=3; ${hour} + (${min} / 60)" | bc)

  echo "today: weekday"
  echo "now: ${now}"

  # 集中モードを取得
  focusmode="$(/opt/homebrew/bin/focus)"

  # 地震情報を取得
  latest_earthquake_tsux=$(check_latest_earthquake)
  latest_earthquake_offset=$(( TIMESTAMP - latest_earthquake_tsux ))

  # 優先度の高い順に、画面の構成判定を行う
  # 地震 > 運動 > ストレッチ > 睡眠 > ZZZ > 競馬 > Mリーグ > 食事

  ## 直近で緊急地震速報が発生している場合、地震速報を表示する
  ## TODO: ここでテレビ自体のONと入力変更も挟みたい
  if (( ${latest_earthquake_offset} < 3600 )); then
    echo "モード判定: 地震"
    tv_channel1="earthquake"
  
  ## "フィットネス"モードの場合、音を止めておく
  elif [ "${focusmode}" = "${MODE_WORKOUT}" ]; then
    echo "モード判定: フィットネス"
    tv_channel1="fitness"

  ## "ストレッチ"モードの場合、ストレッチ動画を流す
  elif [ "${focusmode}" = "${MODE_STRETCH}" ]; then
    echo "モード判定: ストレッチ"
    tv_channel1="stretch"

  ## "睡眠"モードの場合、睡眠導入用BGMに切り替える
  elif [ "${focusmode}" = "${MODE_SLEEP}" ]; then
    echo "モード判定: 睡眠"
    tv_channel1="sleep-bgm"
  
  ## "睡眠導入"モードの場合、睡眠準備のために夜間用音楽に切り替える
  elif [ "${focusmode}" = "${MODE_PRESLEEP}" ]; then
    echo "モード判定: 睡眠導入"
    tv_channel1="nightmode-bgm"
  
  ## 中央競馬/ダート重賞番組が放送されている場合、グリーンチャンネルに変更する
  elif is_national_racetime || is_dirt_grade_race; then
    echo "モード判定: 競馬"
    tv_channel1="greench"

  ## Mリーグの放送中ならMリーグをつける
  elif is_mleague_onair; then
    echo "モード判定: Mリーグ"
    restart_stream
    tv_channel1="mahjong"

  ## "食事"モードの場合はニュースをつける
  elif [ "${focusmode}" = "${MODE_MEAL}" ]; then
    echo "モード判定: 食事"
    tv_channel1="news-domestic"
    tv_channel2="news-global"
  
  ## 特にどれにも該当しなかった場合はモードなしとする
  else
    echo "モード判定: なし"
  fi

  # デフォルト外項目のみterraformに変数として渡す
  for var in ${TFVARS[@]}; do
    if [[ -n "${!var}" ]]; then
      echo "${var}: ${!var}"
      export TF_VAR_${var^^}=${!var}
    fi
  done

  # 設定反映(org/adminをimportしてない場合は再度importする)
  ${TF} init -upgrade

  is_exist_admin=$(${TF} state list grafana_user.admin)
  is_exist_main=$(${TF} state list grafana_organization.main)
  if [[ "${is_exist_admin}" == "" ]]; then
    ${TF} import grafana_user.admin 1
  fi
  if [[ "${is_exist_main}" == "" ]]; then
    ${TF} import grafana_organization.main 1
  fi

  ${TF} apply ${TF_OPTIONS}

  # 現在時刻のtfstateをバックアップする
  if [[ $(date "+%M") == "00" ]]; then
    mkdir -p ${HOME}/tfstate.bak
    ts=$(date "+%Y%m%d%H%M")
    cp /tmp/terraform.tfstate ${HOME}/tfstate.bak/terraform.tfstate.${ts}
  fi

}

main $@
