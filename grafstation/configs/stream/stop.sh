#!/bin/zsh

function unload_launchd() {
    export LA_DOMAIN=${1:?}
    local LA="${HOME}/Library/LaunchAgents"
    local PLIST_PATH="${LA}/${LA_DOMAIN}.plist"
    if [[ -f ${PLIST_PATH} ]]; then
        chmod 664 ${PLIST_PATH}
        if ! launchctl list ${LA_DOMAIN} &> /dev/null; then
            launchctl unload -w ${PLIST_PATH}
        fi
    fi
}

function main() {
    export STREAM_KEY=${1:-"stream"}
    unload_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.stl"
    unload_launchd "io.lkj.life.dashboard.grafstation.stream.${STREAM_KEY}.vlc"
}

main $@
