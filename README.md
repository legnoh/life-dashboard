# life-metrics-grafana-deployment

Usage
----

### test on local

```sh

```

やること
----

- イメージをメモリーカードに焼く際、RaspberryPi Imager上でいくつか手を入れる
  - SSHの初期有効化設定を加える(`/boot/ssh`)
    - https://www.raspberrypi.org/documentation/computers/remote-access.html#enabling-the-server
  - WiFiの接続先情報を加える(`/wpa_supplicant.conf`)
    - https://www.raspberrypi.org/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi
- 起動して電源オン
  - SSHして以下を実行
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
      - docker-compose で container/docker-compose.yml のコンテナたちを起動状態にする
      - grafana-kiosk で Grafana のページを開いて、初期状態でフルスクリーン化する
      - ネットワークが切断された場合、自動的にWifiを起動し直すcrontabを仕掛ける
