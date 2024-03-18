#!/bin/bash

STREAM_START_FILE="/tmp/start.stream"

function load_launchd() {
    export LA_DOMAIN=${1:?}
    local TEMPLATE_PATH=${2:?}
    local LA="${HOME}/Library/LaunchAgents"
    local PLIST_PATH="${LA}/${LA_DOMAIN}.plist"

    /opt/homebrew/bin/envsubst < ${TEMPLATE_PATH} > ${PLIST_PATH}
    chmod 664 ${PLIST_PATH}
    if launchctl list ${LA_DOMAIN} == 0; then
        launchctl unload -w ${PLIST_PATH}
    fi
    plutil -lint ${PLIST_PATH}
    launchctl load -w ${PLIST_PATH}
    launchctl list ${LA_DOMAIN}
}

function main() {
    export STREAMLINK_ORIGIN_URL=${1:?}
    export STREAMLINK_HTTP_PORT=${2:-"45081"}
    export STREAM_KEY=${3:-"stream"}
    export STREAMLINK_HTTP_URL="http://grafstation.local:${STREAMLINK_HTTP_PORT}"
    load_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.stl" "./stl.plist"
    sleep 10
    load_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.vlc" "./vlc.plist"
    touch ${STREAM_START_FILE} # 開始時刻把握のためにファイルを更新する
}

main $@
