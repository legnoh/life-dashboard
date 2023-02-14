[Unit]
Description=Grafana Kiosk
Documentation=https://github.com/grafana/grafana-kiosk
Documentation=https://grafana.com/blog/2019/05/02/grafana-tutorial-how-to-create-kiosks-to-display-dashboards-on-a-tv
After=network.target graphical.target

[Service]
User=pi
ExecStart=/usr/bin/grafana-kiosk -URL=http://localhost:3000/d/jTY6Raggz&from=now-1h&to=now
Restart=always

[Install]
WantedBy=graphical.target
