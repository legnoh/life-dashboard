global:
  scrape_interval:     15s 
  evaluation_interval: 15s 
  external_labels:
      monitor: 'codelab-monitor'

scrape_configs:
  - job_name: 'moneyforward'
    metrics_path: /moneyforward.prom
    static_configs:
      - targets: [ staticfile-exporter:80 ]
    scrape_interval: 1800s
  - job_name: 'asken'
    metrics_path: /asken.prom
    static_configs:
      - targets: [ staticfile-exporter:80 ]
    scrape_interval: 1800s
  - job_name: 'withings'
    metrics_path: /withings.prom
    static_configs:
      - targets: [ staticfile-exporter:80 ]
    scrape_interval: 1800s
  - job_name: 'todoist'
    static_configs:
      - targets: [ 'todoist-exporter:9102' ]
    scrape_interval: 60s
  - job_name: 'openweather'
    static_configs:
      - targets: [ 'openweather-exporter:9103' ]
    metric_relabel_configs:
    - source_labels: [__name__]
      regex: '(go|process|promhttp)_(.*)'
      action: drop
    scrape_interval: 60s
  - job_name: 'tado'
    static_configs:
      - targets: [ 'tado-monitor:9104' ]
    metric_relabel_configs:
    - source_labels: [__name__]
      regex: '(go|process|promhttp)_(.*)'
      action: drop
    scrape_interval: 60s

remote_write:
- url: https://prometheus-prod-10-prod-us-central-0.grafana.net/api/prom/push
  basic_auth:
    username: ${GRAFANA_REMOTE_WRITE_USERNAME}
    password: ${GRAFANA_REMOTE_WRITE_API_KEY}
