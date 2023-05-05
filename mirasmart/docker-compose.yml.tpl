version: '3'
services:
  node-exporter:
    container_name: node-exporter
    image: prom/node-exporter:latest
    command: ['--path.rootfs=/host']
    network_mode: host
    pid: host
    restart: always
    volumes:
      - '/:/host:ro,rslave'
  smartmeter-exporter:
    container_name: smartmeter-exporter
    image: legnoh/smartmeter-exporter:latest
    ports: [ 9107:8000 ]
    restart: always
    environment:
      SMARTMETER_LOGLEVEL: 20
      SMARTMETER_ID: ${SMARTMETER_ID}
      SMARTMETER_PASSWORD: ${SMARTMETER_PASSWORD}
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
  mirakc:
    container_name: mirakc
    image: collelog/mirakc:latest-alpine-rpi4-64
    ports: [ 40772:40772 ]
    init: true
    restart: always
    environment:
      TZ: Asia/Tokyo
      RUST_LOG: info
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - mirakc-epg:/var/lib/mirakc/epg
      - ./mirakc-config.yml:/etc/mirakc/config.yml:ro
    devices:
      - /dev/px4video0
      - /dev/px4video1
      - /dev/px4video2
      - /dev/px4video3
      - /dev/bus/usb
volumes:
  mirakc-epg:
    name: mirakc_epg
    driver: local
