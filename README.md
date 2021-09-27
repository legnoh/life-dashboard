# life-metrics-grafana-deployment

- RaspberryPi で人生に必要なメトリクスを取得・監視するための Prometheus デプロイ用セット。
- 慣れれば1時間かからないくらいで必要なものが揃うようになっている。
- GitHub Actions の self-hosted ランナーによってデプロイされる。

Usage
----

TBD

やること
----

- イメージをメモリーカードに焼く際、RaspberryPi Imager上でいくつか手を入れる
  - SSHの初期有効化設定を加える(`/boot/ssh`)
    - https://www.raspberrypi.org/documentation/computers/remote-access.html#enabling-the-server
  - WiFiの接続先情報を加える(`/wpa_supplicant.conf`)
    - https://www.raspberrypi.org/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi
- 起動して電源オン
  - SSHして以下を実行
    - `sudo raspi-config` で以下を実行
      - `2 Display Options` -> `D4 Screen Blanking` -> `<No>`
    - GitHub Action hosted runner をインストールして、service起動状態にする
      - https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
        - https://github.com/legnoh/life-metrics-grafana-deployment/settings/actions/runners
      - https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service
        ```sh
        cd /actions-runner
        sudo ./svc.sh install
        sudo ./svc.sh start
        sudo ./svc.sh status
        ```
    - このリポジトリの GitHub Action を使って、以下を実行する
      - Docker をインストールする
      - docker-compose をインストールする
      - docker-compose で docker/docker-compose.yml のコンテナたちを起動状態にする
      - grafana-kiosk で Grafana のページを開いて、初期状態でフルスクリーン化する
      - ネットワークが切断された場合、自動的にWifiを起動し直すcrontabを仕掛ける

お品書き
----

|name|desc|
|---|---|
| [legnoh/asken-exporter](https://github.com/legnoh/asken-exporter) | あすけん の食事スコア、アドバイス |
| [legnoh/moneyforward-exporter](https://github.com/legnoh/moneyforward-exporter) | MoneyForward ME の 残高、資産、負債、引落予定額 |
| [legnoh/withings-exporter](https://github.com/legnoh/withings-exporter) | Withings の 身体測定情報、アクティビティ、睡眠データ |
| [legnoh/openweather-exporter](https://github.com/legnoh/openweather-exporter) | OpenWeatherMap の 指定地点の天気、温度、湿度 などの気象情報 |
| [clambin/tado-monitor](https://github.com/clambin/tado-exporter) | Tado° の室内温度、湿度 などの計測情報 |
| [legnoh/todoist-exporter](https://github.com/legnoh/todoist-exporter) | Todoist の特定フィルターのタスク残数 |
