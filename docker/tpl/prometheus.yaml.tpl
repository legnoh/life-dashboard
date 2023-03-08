global:
  scrape_interval:     15s 
  evaluation_interval: 15s 
  external_labels:
      monitor: 'codelab-monitor'

scrape_configs:
  - job_name: 'node'
    static_configs:
    - targets: [ node-exporter:9100 ]
    scrape_interval: 60s
  - job_name: 'moneyforward'
    metrics_path: /moneyforward.prom
    static_configs:
      - targets: [ staticfile-exporter:80 ]
    scrape_interval: 300s
  - job_name: 'asken'
    metrics_path: /asken.prom
    static_configs:
      - targets: [ staticfile-exporter:80 ]
    scrape_interval: 300s
  - job_name: 'withings'
    static_configs:
      - targets: [ withings-exporter:9108 ]
    scrape_interval: 60s
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
  - job_name: 'snmp'
    metrics_path: "/snmp"
    params:
      module: [ ${SNMP_EXPORTER_MODULE_NAME} ]
      target: [ ${SNMP_TARGET_IP} ]
    static_configs:
      - targets: [ 'snmp-exporter:9116' ]
    metric_relabel_configs:
    - source_labels: [__name__]
      regex: '(go|process|promhttp)_(.*)'
      action: drop
  - job_name: 'smartmeter'
    static_configs:
      - targets: [ 'smartmeter-exporter:9107' ]
    metric_relabel_configs:
    - source_labels: [__name__]
      regex: '(go|process|python|promhttp)_(.*)'
      action: drop
    scrape_interval: 60s
  - job_name: 'speedtest'
    metrics_path: /probe
    params:
      script: [speedtest]
    static_configs:
      - targets: [ 'speedtest-exporter:9469' ]
    scrape_interval: 60m
    scrape_timeout: 90s

remote_write:
- url: https://prometheus-prod-10-prod-us-central-0.grafana.net/api/prom/push
  basic_auth:
    username: ${GRAFANA_REMOTE_WRITE_USERNAME}
    password: ${GRAFANA_REMOTE_WRITE_API_KEY}
