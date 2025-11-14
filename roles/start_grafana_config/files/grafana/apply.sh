#!/usr/bin/env zsh

# set -x

TIMESTAMP=$(date "+%s")

JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"
BREW="/opt/homebrew/bin/brew"
STREAMLINK="/opt/homebrew/bin/streamlink"

ABEMA_JWT_TOKEN=${ABEMA_JWT_TOKEN:-""}
GREENCH_EMAIL=${GREENCH_EMAIL:?}
GREENCH_PASSWORD=${GREENCH_PASSWORD:?}

ABEMA_SLOTS_FILE="/tmp/abema_slots.json"
DIRT_RACE_JSON="/tmp/dirt_races.json"
GCH_ONAIR_JSON_CH1="/tmp/gch_onair_ch1.json"
GCH_ONAIR_JSON_CH2="/tmp/gch_onair_ch2.json"
GCH_ONAIR_JSON_CH3="/tmp/gch_onair_ch3.json"
GCH_ONAIR_JSON_CH4="/tmp/gch_onair_ch4.json"
GCH_ONAIR_JSON_CH5="/tmp/gch_onair_ch5.json"
GCH_NOW_ONAIR_TITLE_CH1="/tmp/gch_now_onair_ch1.txt"
GCH_NOW_ONAIR_TITLE_CH2="/tmp/gch_now_onair_ch2.txt"
GCH_NOW_ONAIR_TITLE_CH3="/tmp/gch_now_onair_ch3.txt"
GCH_NOW_ONAIR_TITLE_CH4="/tmp/gch_now_onair_ch4.txt"
GCH_NOW_ONAIR_TITLE_CH5="/tmp/gch_now_onair_ch5.txt"
GCH_STREAMS_TFVARS_FILE="/tmp/gch.tfvars.json"
STREAM_START_FILE="/tmp/start.stream"


MODE_MEAL="食事"
MODE_CHILL="食後"
MODE_WORKOUT="フィットネス"
MODE_STRETCH="ストレッチ"
MODE_PRESLEEP="睡眠導入"
MODE_SLEEP="睡眠"
MODE_GAME="ゲーム"
MODE_LIVE="配信中"

TFVARS=(
  tv_channel1
  tv_channel2
  is_tv_channel1_muted
  is_tv_channel2_muted
)
TF_OPTIONS=${TERRAFORM_OPTIONS:-"-auto-approve -var-file=/tmp/gch.tfvars.json"}

# ABEMAの番組表をバックアップする
function fetch_abema_slots_data() {
  local token=${1:?}
  local timetable_url="https://api.p-c3-e.abema-tv.com/v1/timetable/dataSet?debug=false"

  if [[ ! -e "${ABEMA_SLOTS_FILE}" ]] || [[ $(date "+%M") == "55" ]]; then

    # たまに制御文字が紛れ込むことがあるので消す
    curl -o - -q -L \
      -H "Accept-Encoding: gzip" \
      -H "Authorization: Bearer ${token}" "${timetable_url}" \
    | gunzip \
    | perl -CSD -pe 's/\p{C}//g' \
    > ${ABEMA_SLOTS_FILE}
  fi
}

# 中央競馬中継放送情報を取得する
function fetch_gch_onair_data() {
  local yesterday=$(date -v '-1d' "+%Y%m%d")
  local tomorrow=$(date -v '+1d' "+%Y%m%d")
  if [[ ! -e "${GCH_ONAIR_JSON_CH1}" ]] || [[ $(date "+%M") == "00" ]]; then
    for channel_code in {1..5}
    do
      local url="https://sp.gch.jp/api_epg/?channel_code=ch${channel_code}&date_from=${yesterday}&date_to=${tomorrow}"
      local filename=$(eval echo '$'GCH_ONAIR_JSON_CH${channel_code})
      curl -s -o "${filename}" "${url}"
    done
  fi
}

# ダートレース情報を取得する
function fetch_dirt_race_data() {
  local json_url="https://jra.event.lkj.io/graderaces_dirtgrade.json"

  if [[ ! -e "${DIRT_RACE_JSON}" ]] || [[ $(date "+%M") == "00" ]]; then
    curl -s -o "${DIRT_RACE_JSON}" "${json_url}"
  fi
}

# グリーンチャンネルの指定チャンネルでストリームURLを取得する
function get_greench_stream_url() {
  local channel_code=${1:?}
  if [[ ${channel_code} == "1" ]]; then
    ${STREAMLINK} "https://sp.gch.jp/#ch${channel_code}" \
    --greenchannel-email="${GREENCH_EMAIL}" \
    --greenchannel-password="${GREENCH_PASSWORD}" \
    --greenchannel-low-latency=true \
    --stream-url
  else
    ${STREAMLINK} "https://sp.gch.jp/#ch${channel_code}" \
    --greenchannel-email "${GREENCH_EMAIL}" \
    --greenchannel-password "${GREENCH_PASSWORD}" \
    --stream-url
  fi
}

# グリーンチャンネルの現在放送中の番組タイトルを取得する
function get_greench_now_onair_title() {
  local channel_code=${1:-"1"}
  local filename=$(eval echo '$'GCH_ONAIR_JSON_CH${channel_code})
  local ts=$(date +%s)
  local title=$(cat ${filename} \
    | ${JQ} -r "[ .[][] \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | select( .live_start_datetime < ${ts} and .live_end_datetime > ${ts} ) ] | .[0].program_name")
  local category_code=$(cat ${filename} \
    | ${JQ} -r "[ .[][] \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | select( .live_start_datetime < ${ts} and .live_end_datetime > ${ts} ) ] | .[0].category_code")
  if [[ "${title}" == "null" ]] || [[ "${category_code}" == "L999" ]]; then
    echo "放送休止"
  else
    echo "${title}"
  fi
}

# Mリーグをやっているか確認する(フェニックスの出場日のみ)
function get_mleague_onair_channel_id() {

  local now_unixtime=${TIMESTAMP}
  local filepath=${ABEMA_SLOTS_FILE}

  local mleague_channel_id=$(cat ${filepath} \
    | ${JQ} -r ".slots[] \
      | select( (.channelId == \"mahjong\" or .channelId == \"mahjong-live\") and .mark.live == true ) \
      | select(.title | contains(\"Mリーグ\") ) \
      | select(.startAt < ${now_unixtime} and .endAt > ${now_unixtime} ) \
      | select(.detailHighlight | contains(\"セガサミーフェニックス\") )
      | .channelId")
    if [[ ${mleague_channel_id} != "" ]]; then
      echo "${mleague_channel_id}"
    else
      echo ""
    fi
}

# ストリームの開始時間を確認し、5時間以上経過していたら再起動する
function restart_stream(){
  local channelId=${1:-"mahjong"}
  local mleague_url="https://abema.tv/now-on-air/${channelId}"

  if [[ ! -e "${STREAM_START_FILE}" ]]; then
    echo "ストリームを再起動します(ファイルなし)"
    cd ../stream && ./start.sh "${mleague_url}" && cd -

    # キャッシュクリアのため、grafana-kioskも再起動する
    ${BREW} services restart grafana-kiosk
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
    return 0
  fi
}

# ストリームを停止する
function stop_stream(){
  # ストリーム開始ファイルがある場合のみ停止処理を実行する
  if [[ -e "${STREAM_START_FILE}" ]]; then
    echo "ストリームを停止します"
    cd ../stream && ./stop.sh && cd -
    rm -rf ${STREAM_START_FILE}
    rm -rf ${HOME}/grafstation/configs/html/stream/*.ts
    return 0
  fi
}

# 中央競馬の中継中か確認する
function is_national_racetime(){
  local ts=$(date +%s)
  local num=0

  num=$(cat ${GCH_ONAIR_JSON_CH1} \
    | ${JQ} -r "[ .[][] \
      | select(.category_name==\"中継\") \
      | select(.program_name | contains(\"中央競馬\")) \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | select( .live_start_datetime < ${ts} and .live_end_datetime > ${ts} ) ] | length" \
  )

  if [[ "${num}" == "" ]]; then
    num=0
  fi
  if [[ ${num} > 0 ]]; then
    echo "中央競馬判定: 有"
    return 0
  else
    echo "中央競馬判定: 無"
    return 1
  fi
}

# ダートグレード競走中継をやっているか確認する
function is_dirt_grade_race() {
  local num=0

  # レース時間の1時間前からレース終了後15分までを放送時間とみなす
  race_num=$(cat ${DIRT_RACE_JSON} \
    | ${JQ} -r "[.races[] | select(.start_at - ${TIMESTAMP} < 3600 and .end_at + 900 > ${TIMESTAMP})] | length"
  )

  # かつ、グリーンチャンネルで中継が行われているか確認する
  live_num=$(cat ${GCH_ONAIR_JSON_CH1} \
    | ${JQ} -r "[ .[][] \
      | select(.category_name==\"中継\") \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | select( .live_start_datetime < ${TIMESTAMP} and .live_end_datetime > ${TIMESTAMP} ) ] | length" \
  )

  if [[ "${race_num}" == "" ]]; then
      num=0
    fi
    if [[ ${race_num} > 0 && ${live_num} > 0 ]]; then
      echo "ダートグレード競走判定: 有"
      return 0
    else
      echo "ダートグレード競走判定: 無"
      return 1
    fi
}

# 海外競馬の中継中か確認する
function is_world_racetime(){
  local ts=$(date +%s)
  local num=0

  # 無料中継が行われるのは海外競馬のみなので、この2つの条件で絞る
  num=$(cat ${GCH_ONAIR_JSON_CH1} \
    | ${JQ} -r "[ .[][] \
      | select(.category_name==\"中継\") \
      | select(.is_free==\"1\") \
      | .live_start_datetime = ( .live_start_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | .live_end_datetime   = ( .live_end_datetime | strptime(\"%Y-%m-%d %T\") | strftime(\"%s\") | tonumber ) - 32400 \
      | select( .live_start_datetime < ${ts} and .live_end_datetime > ${ts} ) ] | length" \
  )

  if [[ "${num}" == "" ]]; then
    num=0
  fi
  if [[ ${num} > 0 ]]; then
    echo "海外競馬判定: 有"
    return 0
  else
    echo "海外競馬判定: 無"
    return 1
  fi
}

# GCH_STREAMS の情報を入れるためのtfvarsを生成する
function create_gch_streams_json() {
  local tfvars='{"GCH_STREAMS": []}'
  if [[ ! -e ${GCH_STREAMS_TFVARS_FILE} ]]; then
    tfvars='{"GCH_STREAMS": []}'
  else
    tfvars=$(cat ${GCH_STREAMS_TFVARS_FILE})
  fi

  for channel_code in {1..5}
  do
    # 番組名とキャッシュ済の番組名を取得・比較し、差分がなければスルー、あれば更新
    local program_name=$(get_greench_now_onair_title ${channel_code})
    local title_filename=$(eval echo '$'GCH_NOW_ONAIR_TITLE_CH${channel_code})
    if [[ -e ${title_filename} ]] && [[ "${program_name}" == $(cat ${title_filename}) ]]; then
        echo "ch${channel_code}: ${program_name} (not updated)"
        continue
    else
        echo "ch${channel_code}: ${program_name} (updated!)"
        echo ${program_name} > ${title_filename}
    fi

    # 放送休止でない場合はストリーミングURLを取得
    if [[ ${program_name} != "放送休止" ]]; then
      local stream_url=$(get_greench_stream_url ${channel_code})
    else
      local stream_url="https://dummy.com/"
    fi

    # tfvarsファイルを更新
    local channel_index=$((${channel_code}-1))
    tfvars=$(echo -n ${tfvars} | jq ".GCH_STREAMS[${channel_index}] |= . + {
      \"channel_id\": \"ch${channel_code}\",
      \"program_name\": \"${program_name}\",
      \"stream_url\": \"${stream_url}\",
    }")
    echo -n $tfvars > ${GCH_STREAMS_TFVARS_FILE}
  done
}

# 地震がなかったか確認する
# https://www.p2pquake.net/develop/
function check_latest_earthquake() {
  echo $(curl -s "https://api.p2pquake.net/v2/history?codes=556&limit=1" \
    | ${JQ} -r ".[].time \
      | split(\".\")[0] \
      | strptime(\"%Y/%m/%d %H:%M:%S\") \
      | strftime(\"%s\" | tonumber ) - 32400" \
  )
}

# 現在ダークモードかどうか判定する
function is_dark_mode() {
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    return 0
  else
    return 1
  fi
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
  ts=$(date +%s)
  now=$(echo "scale=3; ${hour} + (${min} / 60)" | bc)

  echo "today: weekday"
  echo "now: ${now}"

  # 集中モードを取得
  focusmode="$(/opt/homebrew/bin/focus get)"

  # Mリーグ放送中かどうか確認
  local mleague_channel_id=$(get_mleague_onair_channel_id)

  # グリーンチャンネルのデータ更新処理
  create_gch_streams_json

  # 地震情報を取得
  latest_earthquake_tsux=$(check_latest_earthquake)
  latest_earthquake_offset=$(( TIMESTAMP - latest_earthquake_tsux ))

  # 優先度の高い順に、画面の構成判定を行う
  # 地震 > 運動 > ストレッチ > 睡眠 > ZZZ > 競馬 > Mリーグ > 食事 > ダークモード > なし

  ## 直近で緊急地震速報が発生している場合、地震速報を表示する
  ## TODO: ここでテレビ自体のONと入力変更も挟みたい
  if (( ${latest_earthquake_offset} < 3600 )); then
    echo "モード判定: 地震"
    tv_channel1="earthquake"

  ## "フィットネス"モードの場合、筋トレ動画を流す
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

  ## "ゲーム"モードの場合、音をミュートする
  elif [ "${focusmode}" = "${MODE_GAME}" ]; then
    echo "モード判定: ゲーム"
    is_tv_channel1_muted=true
    is_tv_channel2_muted=true

  ## "配信中"モードの場合、音をミュートする
  elif [ "${focusmode}" = "${MODE_LIVE}" ]; then
    echo "モード判定: 配信中"
    is_tv_channel1_muted=true
    is_tv_channel2_muted=true

  ## 中央競馬/ダート重賞番組/海外競馬が放送されている場合、グリーンチャンネルに変更する
  elif is_national_racetime || is_dirt_grade_race || is_world_racetime; then
    echo "モード判定: 競馬"
    tv_channel1="greench"

  ## Mリーグの放送中ならMリーグをつける
  elif [[ "${mleague_channel_id}" != "" ]]; then
    echo "モード判定: Mリーグ"
    restart_stream "${mleague_channel_id}"
    tv_channel1="mahjong"

  ## "食事"モードの場合はニュースをつける
  elif [ "${focusmode}" = "${MODE_MEAL}" ]; then
    echo "モード判定: 食事"
    tv_channel1="news-domestic"
    tv_channel2="news-global"
  
  ## "食事"モードの場合はニュースをつける
  elif [ "${focusmode}" = "${MODE_CHILL}" ]; then
    echo "モード判定: 食後"
    tv_channel1="vtuber"
    tv_channel2="greench"
  
  ## ダークモードの場合、夜間用BGMに切り替える
  elif is_dark_mode; then
    echo "モード判定: ダークモード"
    tv_channel1="darkmode-bgm"
  
  ## 特にどれにも該当しなかった場合はモードなしとする
  else
    echo "モード判定: なし"
  fi

  # Mリーグ放送中でない場合、ストリームを停止させておく
  if [[ "${tv_channel1}" != "mahjong" ]]; then
    stop_stream
  fi

  # デフォルト外項目のみterraformに変数として渡す
  for var in ${TFVARS[@]}; do
    if [[ -n "${(P)var}" ]]; then
      echo "${var}: ${(P)var}"
      export TF_VAR_${(U)var}=${(P)var}
    fi
  done

  # 設定反映(org/adminをimportしてない場合は再度importする)
  ${TF} init -upgrade

  is_exist_main=$(${TF} state list grafana_organization.main)
  if [[ "${is_exist_main}" == "" ]]; then
    ${TF} import grafana_organization.main 1
  fi

  ${TF} apply ${(QQ)=TF_OPTIONS}

  # 現在時刻のtfstateをバックアップする
  if [[ $(date "+%M") == "00" ]]; then
    mkdir -p ${HOME}/tfstate.bak
    ts=$(date "+%Y%m%d%H%M")
    cp /tmp/terraform.tfstate ${HOME}/tfstate.bak/terraform.tfstate.${ts}
  fi
}

main $@
