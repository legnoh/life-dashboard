# life-dashboard

- Mac mini で人生に必要なメトリクス・情報を取得するための Prometheus+Grafana セットです。
- 慣れれば1時間かからないくらいで必要なものが揃うようになっています。
- GitHub Actions の self-hosted ランナーによってデプロイされますので、自動でCDが実行できます。
- YouTube, その他動画サービスの情報を画面に出すことができ、動画とメトリクスを一画面で見ることができます。

![dashboard-sample](https://user-images.githubusercontent.com/706834/236629238-3730ee10-3a4b-414e-9699-3c820b05b638.png)

お品書き
----

|name|desc|
|---|---|
| [legnoh/aphorism-exporter](https://github.com/legnoh/aphorism-exporter) | 格言 |
| [legnoh/asken-exporter](https://github.com/legnoh/asken-exporter) | あすけん の食事スコア、アドバイス |
| [legnoh/moneyforward-exporter](https://github.com/legnoh/moneyforward-exporter) | MoneyForward ME の 残高、資産、負債、引落予定額 |
| [legnoh/openweather-exporter](https://github.com/legnoh/openweather-exporter) | OpenWeatherMap の 指定地点の天気、温度、湿度 の気象情報 |
| [legnoh/oura-exporter](https://github.com/legnoh/oura-exporter) | Oura Ring の 各種スコア(アクティビティ、コンディション、睡眠) |
| [kenfdev/remo-exporter](https://github.com/kenfdev/remo-exporter) | NatureRemo の の計測情報 |
| [prometheus/snmp_exporter](https://github.com/prometheus/snmp_exporter) | 宅内通信回線の利用状況 |
| [billimek/prometheus-speedtest-exporter](https://github.com/billimek/prometheus-speedtest-exporter) | Speedtest で計測した宅内通信回線の最高速度 |
| [legnoh/reminders-exporter](https://github.com/legnoh/reminders-exporter) | リマインダーの期限切れ・特定リストのタスク残数 |
| [legnoh/withings-exporter](https://github.com/legnoh/withings-exporter) | Withings の 身体測定情報 |
| [RSS一覧 - Yahoo!ニュース](https://news.yahoo.co.jp/rss) | 最新ニュースのヘッドライン |
| [legnoh/youtube-playlist-creator](https://github.com/legnoh/youtube-playlist-creator) | 嗜好に基づいたYouTubeLiveのプレイリスト生成 |

Installation
----

- GitHub Action hosted runnerをインストールして、serviceとして起動した状態にする
    - https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
    - https://github.com/legnoh/life-dashboard/settings/actions/runners
    - https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service
    ```sh
    cd ~/actions-runner
    sudo ./svc.sh install
    sudo ./svc.sh start
    sudo ./svc.sh status
    ```
- GitHub Action(Ansible)を使って、以下を実行する
  - Homebrew をインストールする
  - 必要な設定やパッケージをインストールする
  - 設定ファイルを作成・コピーする
  - SNMP設定ファイルを作成する
  - Dockerコンテナを立ち上げる
  - Terraform経由でGrafanaの基本設定を投入する
  - grafana-kioskを起動する
