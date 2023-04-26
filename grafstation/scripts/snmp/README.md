SNMP 設定覚書
====

あらかじめ決めておく
----

- SNMPv3 コンテキスト名
  - [18.14 SNMPv3 コンテキスト名の設定](http://www.rtpro.yamaha.co.jp/RT/manual/nvr700w_nvr510/snmp/snmpv3_context_name.html)
- SNMPv3 パスワード・暗号化方式
  - [18.15 SNMPv3 USM で管理するユーザーの設定](http://www.rtpro.yamaha.co.jp/RT/manual/nvr700w_nvr510/snmp/snmpv3_usm_user.html)
- SNMPv3 アクセス許可元の設定
  - [18.16 SNMPv3 によるアクセスを許可するホストの設定](http://www.rtpro.yamaha.co.jp/RT/manual/nvr700w_nvr510/snmp/snmpv3_host.html)

NVR510側への設定
----

1. NVR510のSSH許可設定を有効化し、以下の設定を流し込む

```sh
# 表示をUTF-8へ変更
console character ja.utf8
save

# 管理者権限へ変更
administrator

# ユーザ作成
snmpv3 usm user ${user_id} ${user_name} sha ${auth_pass} aes128-cfb ${priv_pass}

# コンテキスト作成
snmpv3 context name ${context_name}

# 閲覧権限付与
snmpv3 host any user ${user_id}

# 終了
save
```

snmp-exporter config 作成
---

```sh
export SNMP_USERNAME="..."
export SNMP_PASSWORD="..."
export SNMP_PRIV_PASSWORD="..."

./generate.sh
```
