#!/opt/homebrew/bin/bash

set -x

echo "---------------------------------"
date "+%Y/%m/%d %H:%M:%S"
ts=$(date "+%Y%m%d%H%M")
tsux=$(date "+%s")

JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"

EPGS_HOST="grafstation.local:8888"
CHANNELS_JSON=$(curl "http://${EPGS_HOST}/api/channels" 2>/dev/null)

TFVARS=(
  tv_channel1_id
  tv_channel2_id
  is_tv_channel1_muted
  is_tv_channel2_muted
  is_youtube_muted
  is_daymode
  is_refreshtime
  is_refreshtime_shuffle
  is_racetime
)
TF_OPTIONS=${TERRAFORM_OPTIONS:-"-auto-approve"}

# ジャンル検索関数(第1引数/第2引数に入れたもので現在放送中のチャンネルを返す)
function search_channel_by_genre(){
  local genre=${1:-"8"}
  local subgenre=${2:-""}
  local now="$(date +%s)000"
  local broadcasting=$(curl -s "http://${EPGS_HOST}/api/schedules/broadcasting?isHalfWidth=true")
  local channel=""

  if [[ ${subgenre} == "" ]]; then
    channel=$(echo ${broadcasting} \
      | ${JQ} -r "[.[] \
        | select( .programs[0].genre1==${genre} )][0]")
  elif [[ ${subgenre} != "" ]]; then
    channel=$(echo ${broadcasting} \
      | ${JQ} -r "[.[] \
        | select( .programs[0].genre1==${genre} \
            and .programs[0].subGenre1==${subgenre} \
        )][0]")
  fi

  if [[ "${channel}" != "null" ]]; then
    echo ${channel} | ${JQ} -r ".channel.id"
  fi
}

# 中央競馬をやっている日か確認する
function is_national_raceday(){
    local yyyymm=${1:-$(date "+%Y%m")}
    local day=${2:-$(date "+%-d")}
    local num=0

    num=$(curl -s "https://jra.jp/keiba/common/calendar/json/${yyyymm}.json" \
        | ${JQ} -r ".[].data[] | select(.date==\"${day}\") | .info[].race | length")
    
    if [[ "${num}" == "" ]]; then
      num=0
    fi
    if [[ ${num} > 0 ]]; then
      echo 1
    else
      echo 0
    fi
}

# ダートグレードレース番組をやっているかを確認する
function search_dirt_grade_race() {
  echo "$(curl -s "http://${EPGS_HOST}/api/schedules/broadcasting?isHalfWidth=true" \
    | ${JQ} ".[] \
      | select( .channel.name == \"グリーンチャンネル\" ) \
      | .programs[0] \
      | select( .description | test(\"(Jpn1|Jpn2|Jpn3)\") )" )"
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

# EPGStationのチャンネル情報を取得して変数展開
len=$(echo ${CHANNELS_JSON} | ${JQ} length)
for i in $( seq 0 $(($len - 1)) ); do
  channel_info=$(echo "${CHANNELS_JSON}" | ${JQ} -r ".[${i}]")
  channel_name=$(echo "${channel_info}" | ${JQ} -r ".halfWidthName")
  channel_slag=$(echo "${channel_info}" | ${JQ} -r ".channelType + .channel")
  channel_id=$(echo "${channel_info}" | ${JQ} -r ".id")
  val_name="CHANNEL_${channel_slag}"

  if [ -z "${!val_name}" ]; then
    echo "${channel_name}: CHANNEL_${channel_slag}=${channel_id}"
    eval ${val_name}="${channel_id}"
  fi
done

# 曜日・時間を取得
weekday=$(date +%u) # 月-日 = 1-7
hour=$(date +%-H)
min=$(date +%-M)
now=$(echo "scale=3; ${hour} + (${min} / 60)" | bc)

# 平日の場合
if [ ${weekday} -le 5 ]; then
  echo "today: weekday"
  echo "now: ${now}"

  # 0:00~05:45 / 停止
  if [ $( echo "${now} < 5.75" | bc ) == 1 ]; then
    :

  # 5:45~06:30 / BSテレ東(YouTubeミュート解除)
  elif [ $( echo "${now} < 6.5" | bc ) == 1 ]; then
    tv_channel1_id=${CHANNEL_BSBS1_2}
    is_youtube_muted=false

  # 6:30~07:00 / ストレッチ動画+BSテレ東
  elif [ $( echo "${now} < 6.583" | bc ) == 1 ]; then
    is_refreshtime=true
    tv_channel2_id=${CHANNEL_BSBS1_2}

  # 07:00~07:55 / BSテレ東(YouTubeミュート解除)
  elif [ $( echo "${now} < 7.916" | bc ) == 1 ]; then
    tv_channel1_id=${CHANNEL_BSBS1_2}
    is_youtube_muted=false

    # 火曜/金曜 7:38~7:43 フジテレビ(ちいかわ)
    if [ ${weekday} == 2 ] || [ ${weekday} == 5 ]; then
      if [ $( echo "${now} > 7.633" | bc ) == 1 ] && [ $( echo "${now} < 7.716" | bc ) == 1 ]; then
        tv_channel1_id=${CHANNEL_GR21}
        is_tv_channel1_muted=false
        is_youtube_muted=true
      fi
    fi

  # 07:55~09:55 / BGMのみ
  elif [ $( echo "${now} < 9.916" | bc ) == 1 ]; then
    is_tv_channel1_muted=false
  
  # 09:55~10:00 / NHK総合1(体操)
  elif [ $( echo "${now} < 10" | bc ) == 1 ]; then
    tv_channel1_id=${CHANNEL_GR27}
    is_tv_channel1_muted=false
  
  # 10:00~12:00 / ドキュメンタリー・教養（ランダム）
  elif [ $( echo "${now} < 12" | bc ) == 1 ]; then
    tv_channel1_id=$(search_channel_by_genre 8)

  ## 12:00~12:25 / NHK総合1(ミュート解除)
  elif [ $( echo "${now} < 12.416" | bc ) == 1 ]; then
    tv_channel1_id=${CHANNEL_GR27}
    is_tv_channel1_muted=false

  # 12:25~13:00 / BS NHK(YouTubeミュート解除)
  elif [ $( echo "${now} < 13" | bc ) == 1 ]; then
    tv_channel1_id=${CHANNEL_BSBS15_0}
    is_youtube_muted=false

  # 13:00~15:00 / 停止
  elif [ $( echo "${now} < 15" | bc ) == 1 ]; then
    :

  # 15:00~15:15 / ストレッチ動画
  elif [ $( echo "${now} < 15.25" | bc ) == 1 ]; then
    is_refreshtime_shuffle=true

  # 14:00~19:00 / ドキュメンタリー・教養（ランダム）
  elif [ $( echo "${now} < 19" | bc ) == 1 ]; then
    tv_channel1_id=$(search_channel_by_genre 8)

  # 19:00~21:30 / ドキュメンタリー・教養（ランダム・YouTubeミュート解除）
  elif [ $( echo "${now} < 21.5" | bc ) == 1 ]; then
    tv_channel1_id=$(search_channel_by_genre 8)
    is_youtube_muted=false

  ## 21:30~22:30 / 音楽のみ
  elif [ $( echo "${now} < 22.5" | bc ) == 1 ]; then
    is_tv_channel1_muted=false

  ## 22:30~24:00 / 停止
  else
    :
  fi

# 土日
elif [ ${weekday} -eq 6 ] || [ ${weekday} -eq 7 ] ; then
  echo "today is saturday|sunday"
  echo "now: ${now}"

  # 0:00~06:30 / 停止
  if [ $( echo "${now} < 6.5" | bc ) == 1 ]; then
    :

  # 6:30~07:00 / ストレッチ動画
  elif [ $( echo "${now} < 7" | bc ) == 1 ]; then
    is_refreshtime=true

  # 07:00~21:30 / ドキュメンタリー・教養（ランダム・YouTubeを音つきでつける）
  elif [ $( echo "${now} < 21.5" | bc ) == 1 ]; then
    tv_channel1_id=$(search_channel_by_genre 8)
    is_youtube_muted=false

  ## 21:30~22:30 / 音楽のみ
  elif [ $( echo "${now} < 22.5" | bc ) == 1 ]; then
    is_tv_channel1_muted=false

  ## 22:30~24:00 / 停止
  else
    :
  fi

else
  echo "invalid weekday num"
  exit 1
fi

# 中央競馬の放送日は9:00〜17:00までグリーンチャンネルに変更する
if [[ $(is_national_raceday) > 0 ]]; then
  echo "中央競馬の開催日です!"

  if [ $( echo "${now} < 9" | bc ) == 1 ]; then
    :
  elif [ $( echo "${now} < 17" | bc ) == 1 ]; then
    is_racetime=true
    is_tv_channel1_muted=false
    is_youtube_muted=true
  else
    :
  fi
fi

# ダート重賞番組が放送されている場合、強制的にチャンネルをグリーンチャンネルに変更する
if [[ "$(search_dirt_grade_race)" != "" ]]; then
  echo "! ダート重賞番組中のため、グリーンチャンネルをつけます !"
  is_racetime=true
  is_tv_channel1_muted=false
  is_youtube_muted=true
fi

# 直近で緊急地震速報が発生している場合、強制的にチャンネルをNHKに変更する
latest_earthquake_tsux=$(check_latest_earthquake)
latest_earthquake_offset=$(( tsux - latest_earthquake_tsux ))
if (( ${latest_earthquake_offset} < 3600 )); then
  echo "!!! 直近で緊急地震速報が発報されています（NHKをONにします）!!!"
  tv_channel1_id=${CHANNEL_GR27}
  is_tv_channel1_muted=false

  # TODO: ここでテレビ自体のONも挟みたい
fi

# 05:45~17:30までを日中として判定
if [ $( echo "${now} > 5.83" | bc ) == 1 ] && [ $( echo "${now} < 17.5" | bc ) == 1 ]; then
  echo "時間帯: 昼"
  is_daymode=true
else
  echo "時間帯: 夜"
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
set -x
if [[ $(date "+%M") == "00" ]]; then
  mkdir -p ${HOME}/tfstate.bak
  cp /tmp/terraform.tfstate ${HOME}/tfstate.bak/terraform.tfstate.${ts}
fi
