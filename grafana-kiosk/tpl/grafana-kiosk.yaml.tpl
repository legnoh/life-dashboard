# https://github.com/grafana/grafana-kiosk#using-a-configuration-file
general:
  kiosk-mode: full
  autofit: true
  lxde: true
  lxde-home: /home/pi

target:
  login-method: anom
  URL: "http://localhost:3000/"
  playlist: false
  ignore-certificate-errors: false
