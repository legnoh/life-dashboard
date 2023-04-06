grafstation
===

grafana, prometheus と各種 exporter に加え、epgstation のホストを行います。  

Usage
---

### 基本構成を構築

Homebrew と Docker for Mac をインストールしておく。

- [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)
  - 一緒に Command Line Tool も入れてくれる。
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
- 設定等の格納用に`/opt/life-dashboard` ディレクトリを掘っておく
    ```sh
    sudo mkdir -p /opt/life-dashboard/{metrics,configs,withings}
    sudo mkdir -p /opt/life-dashboard/epgstation/{config,data,drop,img,thumbnail,logs,recorded}
    sudo chown -R ${USER}:admin /opt/life-dashboard
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
cp -r grafstation/configs/grafana /opt/life-dashboard/grafana
cp -r grafstation/configs/docker-compose.yml /opt/life-dashboard/configs/
cp -r grafstation/configs/prometheus.yaml /opt/life-dashboard/configs/
cp -r grafstation/configs/tado-config.yaml /opt/life-dashboard/configs/
exit
```

### docker compose start

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git

export OPENWEATHER_CITY="..."
export OPENWEATHER_APIKEY="..."
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

### grafana-kiosk 起動/再起動

```sh
brew services start grafana-kiosk
brew seavices restart grafana-kiosk
```
