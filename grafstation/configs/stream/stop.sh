#!/bin/bash

function unload_launchd() {
    export LA_DOMAIN=${1:?}
    local LA="${HOME}/Library/LaunchAgents"
    local PLIST_PATH="${LA}/${LA_DOMAIN}.plist"
    chmod 664 ${PLIST_PATH}
    if launchctl list ${LA_DOMAIN} != 0; then
        launchctl unload -w ${PLIST_PATH}
    fi
}

function main() {
    export STREAM_KEY=${1:-"stream"}
    unload_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.stl"
    unload_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.vlc"
}

main $@
