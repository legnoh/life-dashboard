#!/opt/homebrew/bin/bash

# set -x

echo "---------------------------------
date "+%Y/%m/%d %H:%M:%S"


JQ="/opt/homebrew/bin/jq"
TF="/opt/homebrew/bin/terraform"

EPGS_HOST="hal-mini.local:8888"
CHANNELS_JSON=$(curl "http://${EPGS_HOST}/api/channels" 2>/dev/null)

TFVARS=(
  tv_channel_id1
  tv_channel_id2
  is_tv_channel1_muted
  is_tv_channel2_muted
  is_youtube_muted
)
TF_OPTIONS=${TERRAFORM_OPTIONS:-"-auto-approve"}

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

# グリーンチャンネルが安定しないので、取れなかった場合固定値を入れておく
# if [ -z "${CHANNEL_BSBS21_2}"]; then
#   channel_name="グリーンチャンネル"
#   channel_slag="BSBS21_2"
#   channel_id="400234"
#   echo "${channel_name}: CHANNEL_${channel_slag}=${channel_id}"
#   eval ${val_name}="${channel_id}"
# fi

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

  # 5:45~07:05 / BSテレ東(ミュート解除)
  elif [ $( echo "${now} < 7.083" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS1_2}
    is_tv_channel1_muted=false
  
  # 07:05~07:55 / BSテレ東
  elif [ $( echo "${now} < 7.916" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS1_2}
    is_youtube_muted=false
  
  # 07:55~12:00 / NHK総合1
  elif [ $( echo "${now} < 12" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR27}
  
  ## 12:00~12:25 / NHK総合1(ミュート解除)
  elif [ $( echo "${now} < 12.416" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR27}
    is_tv_channel1_muted=false

  # 12:25~13:00 / BS NHK
  elif [ $( echo "${now} < 13" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS15_0}
    is_youtube_muted=false
  
  # 13:00~20:54 / NHK総合1
  elif [ $( echo "${now} < 20.9" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR27}
  
  # 20:54~21:54 / BSテレ東
  elif [ $( echo "${now} < 21.9" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS1_2}
  
  # 21:54~23:00 / テレビ東京1
  elif [ $( echo "${now} < 23" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR23}
  
  ## 23:00~24:00 / 停止
  else
    :
  fi

# 土曜日
elif [ ${weekday} -eq 6 ]; then
  echo "today is saturday"
  echo "now: ${now}"

  # 0:00~05:30 / 停止
  if [ $( echo "${now} < 5.5" | bc ) == 1 ]; then
    :

  # 5:30~09:00 / 日テレ
  elif [ $( echo "${now} < 9" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS1_2}
    is_tv_channel1_muted=false
  
  # 09:00~12:00 / グリーンチャンネル
  elif [ $( echo "${now} < 12" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    is_tv_channel1_muted=false
  
  # 12:00~12:15 / グリーンチャンネル + NHK
  elif [ $( echo "${now} < 12.25" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    tv_channel_id2=${CHANNEL_GR27}
    is_tv_channel2_muted=false
  
  # 12:15~18:45 / グリーンチャンネル
  elif [ $( echo "${now} < 18.75" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    is_tv_channel1_muted=false

  # 18:45~23:00 / NHK1
  elif [ $( echo "${now} < 13" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR27}
    is_youtube_muted=false
  
  ## 23:00~24:00 / 停止
  else
    :
  fi

# 日曜日
elif [ ${weekday} -le 7 ]; then
  echo "today is sunday"
  echo "now: ${now}"

    # 0:00~05:50 / 停止
  if [ $( echo "${now} < 5.83" | bc ) == 1 ]; then
    :

  # 5:50~09:00 / テレビ朝日
  elif [ $( echo "${now} < 9" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR24}
    is_tv_channel1_muted=false
  
  # 09:00~12:00 / グリーンチャンネル
  elif [ $( echo "${now} < 12" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    is_tv_channel1_muted=false
  
  # 12:00~12:15 / グリーンチャンネル + NHK
  elif [ $( echo "${now} < 12.25" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    channel2_id=${CHANNEL_GR27}
    channel2_muted=false
  
  # 12:15~17:00 / グリーンチャンネル
  elif [ $( echo "${now} < 17" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_BSBS21_2}
    is_tv_channel1_muted=false
  
  # 17:00~18:45 / TBS
  elif [ $( echo "${now} < 17" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR22}
    is_tv_channel1_muted=false

  # 18:45~21:00 / NHK1
  elif [ $( echo "${now} < 21" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR27}
    is_youtube_muted=false
  
  # 21:00~23:00 / NHK Eテレ
  elif [ $( echo "${now} < 23" | bc ) == 1 ]; then
    tv_channel_id1=${CHANNEL_GR26}
    is_tv_channel1_muted=false
  
  ## 23:00~24:00 / 停止
  else
    :
  fi

else
  echo "invalid weekday num"
  exit 1
fi

# デフォルト外項目のみterraformに変数として渡す
for var in ${TFVARS[@]}; do
  if [[ -n "${!var}" ]]; then
    echo "${var}: ${!var}"
    export TF_VAR_${var^^}=${!var}
  fi
done

# 設定反映
${TF} apply ${TF_OPTIONS}
