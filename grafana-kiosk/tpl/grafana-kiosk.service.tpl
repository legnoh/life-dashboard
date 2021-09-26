[Unit]
Description=Grafana Kiosk
Documentation=https://github.com/grafana/grafana-kiosk
Documentation=https://grafana.com/blog/2019/05/02/grafana-tutorial-how-to-create-kiosks-to-display-dashboards-on-a-tv
After=network.target graphical.target

[Service]
User=pi
Environment="KIOSK_MODE=full"
Environment="KIOSK_AUTOFIT=false"
Environment="KIOSK_LXDE_ENABLED=true"
Environment="KIOSK_LXDE_HOME=/home/pi"
Environment="KIOSK_LOGIN_METHOD=anom"
Environment="KIOSK_IGNORE_CERTIFICATE_ERRORS=false"
Environment="KIOSK_IS_PLAYLIST=true"
ExecStart=/usr/bin/grafana-kiosk

[Install]
WantedBy=graphical.target
