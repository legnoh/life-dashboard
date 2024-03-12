#!/opt/homebrew/bin/bash

# set -x

TIMESTAMP=$(date "+%s")

JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"

ABEMA_JWT_TOKEN=${ABEMA_JWT_TOKEN:-""}

ABEMA_SLOTS_FILE="/tmp/abema_slots.json"
DIRT_RACE_JSON="/tmp/dirt_races.json"
GCH_ONAIR_JSON="/tmp/gch_onair.json"
STREAM_START_FILE="/tmp/start.stream"

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
    echo "ストリームを再起動します"
    ../stream/start.sh "${mleague_url}"
    return 0
  fi

  local now_unixtime=${TIMESTAMP}
  local stream_start_unixtime=$(date -r ${STREAM_START_FILE} +%s)
  local elapsed_time=$(( ${now_unixtime} - ${stream_start_unixtime} ))
  if [[ ${elapsed_time} > 18000 ]]; then
    echo "ストリームを再起動します"
    ../stream/start.sh "${mleague_url}"
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

  # 0:00~05:45 / 停止
  if [ $( echo "${now} < 5.75" | bc ) == 1 ]; then
    :

  # 5:45~06:30 / CH2(Youtube)
  elif [ $( echo "${now} < 6.5" | bc ) == 1 ]; then
    tv_channel1="daymode-bgm"
    is_tv_channel2_muted=false

  # 6:30~06:35 / CH1(ストレッチ)
  elif [ $( echo "${now} < 6.583" | bc ) == 1 ]; then
    tv_channel1="stretch"
    is_tv_channel1_muted=false

  # 07:00~07:55 / CH2(Youtube)
  elif [ $( echo "${now} < 7.916" | bc ) == 1 ]; then
    tv_channel1="daymode-bgm"
    is_tv_channel2_muted=false

  # 07:55~09:55 / CH1(BGM)
  elif [ $( echo "${now} < 9.916" | bc ) == 1 ]; then
    tv_channel1="daymode-bgm"
    is_tv_channel1_muted=false

    # 中央競馬の放送中ならグリーンチャンネルに変更
    if is_national_racetime; then
      tv_channel1="greench"
      is_tv_channel1_muted=false
    fi

  # 09:55~10:00 / ストレッチ
  elif [ $( echo "${now} < 10" | bc ) == 1 ]; then
    tv_channel1="stretch"
    is_tv_channel1_muted=false

    if is_national_racetime; then
      tv_channel2="greench"
    fi

  # 10:00~12:00 / ニュース(国内)
  elif [ $( echo "${now} < 12" | bc ) == 1 ]; then
    tv_channel1="news-domestic"
    if is_national_racetime; then
      tv_channel1="greench"
      tv_channel2="vtuber"
      is_tv_channel1_muted=false
    fi

  ## 12:00~12:20 / ニュース(国内外)
  elif [ $( echo "${now} < 12.33" | bc ) == 1 ]; then
    tv_channel1="news-domestic"
    is_tv_channel1_muted=false
    tv_channel2="news-global"

    if is_national_racetime; then
      tv_channel1="greench"
      tv_channel2="news-domestic"
      is_tv_channel1_muted=false
    fi

  # 12:20~12:40 / ニュース(国外)
  elif [ $( echo "${now} < 12.66" | bc ) == 1 ]; then
    tv_channel1="daymode-bgm"
    is_tv_channel1_muted=false
    if is_national_racetime; then
      tv_channel1="greench"
      is_tv_channel1_muted=false
    fi

  # 12:40~12:55 / 停止
  elif [ $( echo "${now} < 12.916" | bc ) == 1 ]; then
    if is_national_racetime; then
      tv_channel1="greench"
      is_tv_channel1_muted=false
    fi

  # 12:55~13:00 / ストレッチ
  elif [ $( echo "${now} < 13" | bc ) == 1 ]; then
    tv_channel1="stretch"
    is_tv_channel1_muted=false
    if is_national_racetime; then
      tv_channel2="greench"
    fi

  # 13:00~15:00 / ニュース(国内)
  elif [ $( echo "${now} < 15" | bc ) == 1 ]; then
    tv_channel1="news-domestic"
    if is_national_racetime; then
      tv_channel1="greench"
      is_tv_channel1_muted=false
    fi

  # 15:00~15:05 / ストレッチ
  elif [ $( echo "${now} < 15.083" | bc ) == 1 ]; then
    tv_channel1="stretch"
    is_tv_channel1_muted=false
    if is_national_racetime; then
      tv_channel1="greench"
      tv_channel2="stretch"
    fi

  # 15:05~18:55 / 停止
  elif [ $( echo "${now} < 18.916" | bc ) == 1 ]; then
    tv_channel1="news-domestic"
    if is_national_racetime; then
      tv_channel1="greench"
      is_tv_channel1_muted=false
    fi

  # 18:55~19:00 / ストレッチ
  elif [ $( echo "${now} < 19" | bc ) == 1 ]; then
    tv_channel1="stretch"
    is_tv_channel1_muted=false

  # 19:00~21:30 / メインチャンネルのミュートを解除
  elif [ $( echo "${now} < 21.5" | bc ) == 1 ]; then
    is_tv_channel1_muted=false

    # Mリーグの放送中ならMリーグをつける
    if is_mleague_onair; then
      restart_stream
      tv_channel1="mahjong"
      is_tv_channel1_muted=false
    else
      tv_channel1="vtuber"
      is_tv_channel1_muted=false
      tv_channel2="news-domestic"
    fi

  # 21:30~22:30 / 睡眠準備のためBGMのみ
  elif [ $( echo "${now} < 22" | bc ) == 1 ]; then
    is_tv_channel1_muted=false

  ## 22:30~24:00 / 停止
  else
    :
  fi

  # ダート重賞番組が放送されている場合、強制的にチャンネルをグリーンチャンネルに変更する
  if is_dirt_grade_race; then
    echo "ダート重賞が始まります!"
    tv_channel1="greench"
    is_tv_channel1_muted=false
  fi

  # 直近で緊急地震速報が発生している場合、強制的にチャンネルをニュースに変更する
  latest_earthquake_tsux=$(check_latest_earthquake)
  latest_earthquake_offset=$(( TIMESTAMP - latest_earthquake_tsux ))
  if (( ${latest_earthquake_offset} < 3600 )); then
    echo "!!! 直近で緊急地震速報が発報されています（ニュースをONにします）!!!"
    tv_channel1="earthquake"
    is_tv_channel1_muted=false

    # TODO: ここでテレビ自体のONも挟みたい
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
