# https://github.com/grafana/grafana-kiosk#using-a-configuration-file
general:
  kiosk-mode: full
  autofit: true
  lxde: true
  lxde-home: /home/pi

target:
  login-method: gcom
  URL: "${GRAFANA_KIOSK_URL}"
  username: "${GRAFANA_KIOSK_USERNAME}"
  password: "${GRAFANA_KIOSK_PASSWORD}"
  playlists: true
  ignore-certificate-errors: false
