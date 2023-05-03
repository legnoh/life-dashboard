#!/bin/bash

SNMP_EXPORTER_MODULE_NAME=${SNMP_EXPORTER_MODULE_NAME:-"nvr510"}
SNMP_USERNAME=${SNMP_USERNAME:?}
SNMP_PASSWORD=${SNMP_PASSWORD:?}
SNMP_PRIV_PASSWORD=${SNMP_PRIV_PASSWORD:?}
SNMP_CONTEXT_NAME=${SNMP_CONTEXT_NAME:-"nvr510"}

mkdir -p mibs

curl -LO https://github.com/prometheus/snmp_exporter/raw/main/generator/Makefile

curl "http://www.rtpro.yamaha.co.jp/RT/docs/mib/yamaha-private-mib.tar.gz" \
    | tar zx --strip-components 1 -C mibs

make mibs

cat - << EOS > generator.yml
modules:
  ${SNMP_EXPORTER_MODULE_NAME}:
    walk:
      - yrhCpuUtil5sec
      - yrhCpuUtil1min
      - yrhCpuUtil5min
      - yrfRevision
      - yrhInboxTemperature
      - yrfUpTime
      - yrhMemoryUtil
      - ifInOctets
      - ifOutOctets
    version: 3
    auth:
      security_level: authPriv
      auth_protocol: SHA
      priv_protocol: AES
      username: ${SNMP_USERNAME}
      password: ${SNMP_PASSWORD}
      priv_password: ${SNMP_PRIV_PASSWORD}
      context_name: ${SNMP_CONTEXT_NAME}
EOS

docker run -i -v "${PWD}:/opt" prom/snmp-generator generate

cp -r snmp.yml ${HOME}/life-dashboard/configs/snmp.yml
