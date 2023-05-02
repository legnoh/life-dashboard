grafstation
===

grafana, prometheus と各種 exporter に加え、epgstation のホストを行います。  

Usage
---

### 基本構成を構築

Homebrew と Docker for Mac をインストールしておく。

- [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)
  - 最後の指示通りにPATHを通しておく。
    ```sh
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```
- 残りのアプリを全て Homebrew でインストールする。
    ```sh
    curl -Lo ~/.Brewfile https://github.com/legnoh/life-dashboard/raw/main/grafstation/configs/Brewfile
    brew bundle --global
    ```
- 設定等の格納用に`${HOME}/life-dashboard` ディレクトリを掘っておく
    ```sh
    mkdir -p ${HOME}/life-dashboard/{epgstation/{data/{key,streamfiles},drop,img,thumbnail,logs/{EPGUpdater,Operator,Service},recorded},prometheus,metrics,configs,withings}
    ```
- dockerd を起動
    ```sh
    open --background -a Docker
    ```

### snmp-exporter config 作成

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
cd grafstation/scripts/snmp

export SNMP_USERNAME="..."
export SNMP_PASSWORD="..."
export SNMP_PRIV_PASSWORD="..."
./generate.sh
exit
```

### *.prom ダウンロード

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

export GCP_BUCKET_NAME="..."
./grafstation/scripts/download-metrics.sh
exit
```

### その他設定ファイル配置

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
cp -r grafstation/configs/grafana ${HOME}/life-dashboard/configs/
cp -r grafstation/configs/tado-monitor ${HOME}/life-dashboard/configs/
cp -r grafstation/configs/epgstation ${HOME}/life-dashboard/epgstation/config
cp -r grafstation/configs/docker-compose.yml ${HOME}/life-dashboard/configs/
cp -r grafstation/configs/prometheus.yml ${HOME}/life-dashboard/prometheus/
exit
```

### docker compose start

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

export OPENWEATHER_CITY="..."
export OPENWEATHER_API_KEY="..."
export SPEEDTEST_SERVER_IDS="..."
export TADO_USERNAME="..."
export TADO_PASSWORD="..."
export TODOIST_API_KEY="..."
export WITHINGS_CLIENT_ID="..."
export WITHINGS_CONSUMER_SECRET="..."
export WITHINGS_ACCESS_TOKEN="..."
export WITHINGS_TOKEN_TYPE="..."
export WITHINGS_REFRESH_TOKEN="..."
export WITHINGS_USERID="..."
export WITHINGS_EXPIRES_IN="..."
export WITHINGS_CREATED="..."
export WITHINGS_TZ="..."
./grafstation/scripts/start-docker-compose.sh
exit
```

### Terraform による Grafana 設定の流込み

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

# applyをlaunchdで1分おきに実行させる
OPENWEATHER_CITY="..." \
YOUTUBE_PLAYLIST_ID="..." \
HOST=${HOST} \
USER=${USER} \
envsubst < ./grafstation/configs/grafana/apply.plist > ~/Library/LaunchAgents/io.lkj.life.dashboard.grafstation.grafana.apply.plist
chmod 664 ${PLIST_PATH}

launchctl unload -w ~/Library/LaunchAgents/io.lkj.life.dashboard.grafstation.grafana.apply.plist
plutil -lint ~/Library/LaunchAgents/io.lkj.life.dashboard.grafstation.grafana.apply.plist
launchctl load -w ~/Library/LaunchAgents/io.lkj.life.dashboard.grafstation.grafana.apply.plist

tail -f "/tmp/grafana-apply.log"
```

### grafana-kiosk 起動/再起動

```sh
GRAFANA_PLAYLIST=$(curl -s "http://localhost:3000/api/playlists" | jq -r ".[0].uid") \
HOST=${HOST} \
envsubst < grafstation/configs/grafana-kiosk-config.yml > ${HOME}/.grafana-kiosk-config.yml

brew services start grafana-kiosk
```
