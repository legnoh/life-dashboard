# https://github.com/grafana/grafana-kiosk#using-a-configuration-file
general:
  kiosk-mode: full
  autofit: true
  lxde: true
  lxde-home: /home/pi

target:
  login-method: local
  URL: "http://localhost:3000/"
  username: "admin"
  password: "admin"
  playlists: true
  ignore-certificate-errors: false
