mirasmart.local
===

Mac側でカバーできないコンテナ起動を担う Ubuntu サーバです。

- mirakc
  - TVキャプチャを使ったTS抜きを行うため
  - TSの映像的な処理はMac側のEPGStation2で行うのでこちらの担当はTSへの映像変換のみ

Usage
---

### Ubuntu側の基本構成を構築

0. 事前に、作業する mac OS に 1Password, 1Password CLI の2つをインストールしておく。
    - [1Password - Password Manager for Families, Businesses, Teams](https://1password.com/)
      - `brew install 1password`
    - [Command Line Password Manager Tool | 1Password](https://1password.com/downloads/command-line/)
      - `brew install 1password-cli`
    - [Get started | 1Password Developer](https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)
      - Step 3: Turn on the 1Password SSH Agent
      - Step 4: Configure your SSH or Git client
1. ログイン用の公開鍵ペアを作成
    - [Manage SSH keys | 1Password Developer](https://developer.1password.com/docs/ssh/manage-keys/)
      - PrivateKey はed25519で自動生成する。
1. ログイン後のパスワードを作成
    ```sh
    op item create --category="password" \
    --title="mirasmart.local password" \
    --generate-password="64,letters,digits"
    ```
1. [RasberryPi Imager](https://www.raspberrypi.com/software/) で以下の設定にしてメモリーカードを作成。
    - Operating System: `Ubuntu Server 22.04.* LTS (64-bit)`
    - Set hostname: `mirasmart.local`
    - Enable SSH
      - Allow public-key authentication only
        - Set authorized_keys for '${USER}': `op item get mirasmart.local --fields "public key"`
    - Set username and password
      - username: `${USER}`
      - password: `op item get 'mirasmart.local password' --fields 'password'`
    - Configure Wireless LAN
      - `op item list --categories 'WirelessRouter'`
      - Wireless LAN country: `JP`
    - Set locale settings
      - Time zone: `Asia/Tokyo`
      - Keyboard layout: `us`
1. 作成したメモリーカードで RaspberryPi を起動し、SSH ログイン(ここからはUbuntu側での操作)
    ```sh
    ssh mirasmart.local
    ```
1. GitHub Hosted Runner をインストールして常時起動状態にする。
    - [Adding self-hosted runners - GitHub Docs](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)
      - [Add New Runner](https://github.com/legnoh/life-metrics-grafana-deployment/settings/actions/runners/new?arch=arm64&os=linux)
    - [Configuring the self-hosted runner application as a service - GitHub Docs](https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service?platform=linux#installing-the-service)
1. Ubuntu Server は avahi-daemon(`*.local`で到達可能化する) が入っていないので導入。
    ```sh
    # インストール
    sudo apt install -y avahi-daemon

    # 初期設定ファイルをそのままコピーして配置
    sudo cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services

    # 起動
    sudo systemctl start avahi-daemon
    sudo systemctl status avahi-daemon

    # 永続化
    sudo systemctl enable avahi-daemon
    ```
1. Docker Engine をインストールする。
    - [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

### TVキャプチャ稼働用の準備

0. ここではプレクス社の [PX-W3U4](http://www.plex-net.co.jp/product/px-w3u4/) を利用する。
0. 事前にフルサイズのB-CASカードを用意し、有料放送などを見たい場合は別のテレビなどで見れることを確認しておく。
    - プレクス社のチューナーでは契約した有料放送の情報をカードに新しく書込みできない。
      - [有料放送の契約情報はB-CASカードに入っているのですか？ | B-CAS（ビーキャス）](https://www.b-cas.co.jp/support/faq/category08/faq051.html)
      - [ご視聴に必要な操作(受信待機)とは何ですか(スカパー！)](https://helpcenter.skyperfectv.co.jp/articles/knowledge/AID0408)
    - 事前に別のテレビなどでこの受信待機をやっておくと、この問題を回避できる。
1. ドライバインストールのために必要なパッケージをインストールする。
    ```sh
    sudo apt install -y unzip build-essential dkms
    ```
1. px4_drv(chardev版非公式Linuxドライバ) をダウンロード・インストールする。
    - [nns779/px4_drv: Unofficial Linux driver for PLEX PX4/PX5/PX-MLT series ISDB-T/S receivers (not V4L-DVB)](https://github.com/nns779/px4_drv#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
    - TVキャプチャを接続し、認識されていることを確認するところまでやっておく。

### 起動

```sh
git clone https://github.com/legnoh/life-dashboard.git
cd life-dashboard/mirasmart
./start.sh

# ログを確認しておく
docker compose logs -f
```
