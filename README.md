# life-dashboard

- Mac mini で人生に必要なメトリクス・情報を取得するための Prometheus+Grafana セットです。
- 慣れれば1時間かからないくらいで必要なものが揃うようになっています。
- GitHub Actions の self-hosted ランナーによってデプロイされますので、自動でCDが実行できます。
- YouTube, その他動画サービスの情報を画面に出すことができ、動画とメトリクスを一画面で見ることができます。

![dashboard-sample](https://user-images.githubusercontent.com/706834/236629238-3730ee10-3a4b-414e-9699-3c820b05b638.png)

## お品書き

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

## Installation

### 共通

- Apple Account にサインインする
  - [Apple Account にサインインする - Apple サポート (日本)](https://support.apple.com/ja-jp/111001#macos)
- macのコンピュータ名を"grafstation.local"に変更し、ブラウザアクセス用のホスト名を決定する
  - [Macでコンピュータの名前またはローカルホスト名を変更する - Apple サポート (日本)](https://support.apple.com/ja-jp/guide/mac-help/mchlp2322/mac)

### GitHub Actionsを使ってセットアップする場合

- 自己ホストランナーをインストールして、サービスが起動した状態にする
  - [自己ホストランナーの追加 - GitHub Docs](https://docs.github.com/ja/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners)
  - [Add new self-hosted runner · legnoh/life-dashboard](https://github.com/legnoh/life-dashboard/settings/actions/runners/new?arch=arm64&os=osx)
- 自己ホストランナーをサービスとして起動した状態にする
  - [自己ホストランナーアプリケーションをサービスとして設定する - GitHub Docs](https://docs.github.com/ja/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service?platform=mac)
- GitHub Actionの Deploy (Ansible) 経由で以下がすべて実行される
  - Homebrew をインストールする
  - 必要な設定やパッケージをインストールする
  - 設定ファイルを作成・コピーする
  - SNMP設定ファイルを作成する
  - Dockerコンテナを立ち上げる
  - Terraform経由でGrafanaの基本設定を投入する
  - grafana-kioskを起動する

### 手動でセットアップする場合

手動実行する場合、以下の2つから実行方法を選択できる(両方併用しても良い)。

- 管理対象ノードとなるmac上で直接Ansibleを実行する
- コントロールノードとなるmacを別に用意し、SSH経由でAnsibleを実行する

<details>

<summary>管理対象ノードとなるmac上で直接Ansibleを実行する</summary>

- Homebrew をインストールする
  - [macOS（またはLinux）用パッケージマネージャー — Homebrew](https://brew.sh/ja/)
- ansible をインストールする
  ```sh
  brew install ansible
  ```
- このリポジトリをcloneする
  ```sh
  git clone https://github.com/legnoh/life-dashboard.git 
  ```
- [`.env`](./.env.sample) をサンプルからコピーし、必要な環境変数を設定して読み込ませる
  ```sh
  cp .env.sample .env
  vi .env
  source ./.env
  ```
- ansibleを実行してデプロイする
  ```sh
  ansible-playbook site.yml -i inventory/localhost.yml
  ```
</details>

<details>

<summary>コントロールノードとなるmacを別に用意し、SSH経由でAnsibleを実行する</summary>

コントロールノード(**C:** ansibleを実行する端末), 管理対象ノード(**M:** 管理される端末)として記載する。

- **M:** macにSSHできるようにする
  - [リモートコンピュータにMacへのアクセスを許可する - Apple サポート (日本)](https://support.apple.com/ja-jp/guide/mac-help/mchlp1066/mac)
- **C:** ログイン用の秘密鍵/公開鍵を用意し、公開鍵を管理対象ノードに配布する
  ```sh
  username="yourusername"
  pubkey="$(cat yourpubkey.pub)"
  ssh $username@grafstation.local \
    "mkdir -p ~/.ssh \
    && echo \"$pubkey\" > ~/.ssh/authorized_keys \
    && chmod 600 ~/.ssh/authorized_keys"
  ```
- **C/M:** Homebrew をインストールする
  - [macOS（またはLinux）用パッケージマネージャー — Homebrew](https://brew.sh/ja/)
- **C:** ansible をインストールする
  ```sh
  brew install ansible
  ```
- **C:** このリポジトリをcloneする
  ```sh
  git clone https://github.com/legnoh/life-dashboard.git
  ```
- **C:** [`.env`](./.env.sample) をサンプルからコピーし、必要な環境変数を設定して読み込ませる
  ```sh
  cp .env.sample .env
  vi .env
  source ./.env
  ```
- **C:** ansibleを実行してデプロイする。inventoryはgrafstation.ymlに向ける
  ```sh
  ansible-playbook site.yml -i inventory/grafstation.yml
  ```

</details>
