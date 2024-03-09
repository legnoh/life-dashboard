#!/bin/bash

function load_launchd() {
    export LA_DOMAIN=${1:?}
    local TEMPLATE_PATH=${2:?}
    local LA="${HOME}/Library/LaunchAgents"
    local PLIST_PATH="${LA}/${LA_DOMAIN}.plist"

    /opt/homebrew/bin/envsubst < ${TEMPLATE_PATH} > ${PLIST_PATH}
    chmod 664 ${PLIST_PATH}
    launchctl unload -w ${PLIST_PATH}
    plutil -lint ${PLIST_PATH}
    launchctl load -w ${PLIST_PATH}
    launchctl list ${LA_DOMAIN}
}

function main() {
    export STREAMLINK_ORIGIN_URL=${1:?}
    export STREAMLINK_HTTP_PORT=${2:-"45081"}
    export STREAM_KEY=${3:-"stream"}
    export STREAMLINK_HTTP_URL="http://127.0.0.1:${STREAMLINK_HTTP_PORT}"
    load_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.stl" "./stl.plist"
    load_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.vlc" "./vlc.plist"
}

main $@
