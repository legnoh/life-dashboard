[Unit]
Description=Grafana Kiosk
Documentation=https://github.com/grafana/grafana-kiosk
Documentation=https://grafana.com/blog/2019/05/02/grafana-tutorial-how-to-create-kiosks-to-display-dashboards-on-a-tv
After=network.target graphical.target

[Service]
User=pi
ExecStart=/usr/bin/grafana-kiosk -kiosk-mode=full -playlists -URL=http://localhost:3000/playlists/play/1?autofitpanels&from=now-1h&to=now
Restart=always

[Install]
WantedBy=graphical.target
