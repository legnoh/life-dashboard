grafstation
===

grafana, prometheus と各種 exporter のホストを行います。  

Usage
---

### automatic installation

- [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)
  - 最後の指示通りにPATHを通しておく。
    ```sh
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```
- GitHub Action hosted runner をインストールして、service起動状態にする
    - https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
    - https://github.com/legnoh/life-metrics-grafana-deployment/settings/actions/runners
    - https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service
    ```sh
    cd ~/actions-runner
    sudo ./svc.sh install
    sudo ./svc.sh start
    sudo ./svc.sh status
    ```
- このリポジトリの GitHub Action を使って、以下を実行する
    - Homebrew 経由で必要なパッケージをインストールする
    - 設定ファイルをコピーする
    - Dockerコンテナを立ち上げる
    - SNMP設定ファイルを作成する
    - Terraform経由でGrafanaの基本設定を投入する
    - grafana-kioskを起動する


### Manual installation

<details>

<summary>読む場合はこちら</summary>

#### 基本構造を設定

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
- 設定等の格納用に`${HOME}/life-dashboard` ディレクトリ配下に空ディレクトリを作成
    ```sh
    mkdir -p ${HOME}/life-dashboard/{prometheus,configs,withings}
    ```
- dockerd を起動
    ```sh
    open --background -a Docker
    ```

#### snmp-exporter config 作成

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
cd grafstation/scripts/snmp

export SNMP_USERNAME="..."
export SNMP_PASSWORD="..."
export SNMP_PRIV_PASSWORD="..."
./generate.sh
exit
```

#### その他設定ファイル配置 & docker compose start

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

cp -r grafstation/configs/html ${HOME}/life-dashboard/configs/
curl -Lo ${HOME}/life-dashboard/configs/html/mpegts.js \
    https://github.com/xqq/mpegts.js/releases/download/v1.7.3/mpegts.js
curl -Lo ${HOME}/life-dashboard/configs/html/player/mpegts.js.map \
    https://github.com/xqq/mpegts.js/releases/download/v1.7.3/mpegts.js.map
cp -r grafstation/configs/docker-compose.yml ${HOME}/life-dashboard/configs/
cp -r grafstation/configs/nginx.conf ${HOME}/life-dashboard/configs/
cp -r grafstation/configs/prometheus.yml ${HOME}/life-dashboard/prometheus/

export ASKEN_USERNAME="..."
export ASKEN_PASSWORD="..."
export MONEYFORWARD_EMAIL="..."
export MONEYFORWARD_PASSWORD="..."
export OPENWEATHER_CITY="..."
export OPENWEATHER_API_KEY="..."
export SPEEDTEST_SERVER_IDS="..."
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

./grafstation/start.sh

exit
```

#### Terraform apply daemon start

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

cp -r grafstation/configs/grafana ${HOME}/life-dashboard/configs/

PLIST_PATH="${HOME}/Library/LaunchAgents/io.lkj.life.dashboard.grafstation.grafana.apply.plist"

# applyをlaunchdで1分おきに実行させる
OPENWEATHER_CITY="..." \
YOUTUBE_PLAYLIST_ID="..." \
HOST=${HOST} \
USER=${USER} \
envsubst < ./grafstation/configs/grafana/apply.plist > ${PLIST_PATH}
chmod 664 ${PLIST_PATH}

launchctl unload -w ${PLIST_PATH}
plutil -lint ${PLIST_PATH}
launchctl load -w ${PLIST_PATH}

tail -f "/tmp/grafana-apply.log"
```

#### grafana-kiosk 起動/再起動

```sh
GRAFANA_PLAYLIST=$(curl -s -u admin:admin "http://localhost:3000/api/playlists" | jq -r ".[0].uid") \
HOST=${HOST} \
envsubst < grafstation/configs/grafana-kiosk-config.yml > ${HOME}/.grafana-kiosk-config.yml

brew services start grafana-kiosk
```

</details>
