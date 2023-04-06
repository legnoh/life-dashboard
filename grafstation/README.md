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

cp .envrc.sample .envrc
vi .envrc
direnv allow

./generate.sh
exit
```

### *.prom ダウンロード

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
./grafstation/scripts/download-metrics.sh
exit
```

### その他設定ファイル配置

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
cp -r grafstation/configs/grafana /opt/life-dashboard/grafana
cp -r grafstation/configs/docker-compose.yml /opt/life-dashboard/
cp -r grafstation/configs/prometheus.yml /opt/life-dashboard/
cp -r grafstation/configs/tado-config.yml /opt/life-dashboard/
exit
```

### docker compose start

```sh
ghq get -l https://github.com/legnoh/life-dashboard.git
./grafstation/scripts/start-docker-compose.sh
exit
```

### grafana-kiosk 起動/再起動

```sh
brew services start grafana-kiosk
brew seavices restart grafana-kiosk
```
