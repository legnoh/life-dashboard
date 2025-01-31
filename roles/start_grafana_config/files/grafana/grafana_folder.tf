resource "grafana_folder" "atmosphere" {
  title = "空気質"
}

resource "grafana_folder" "electricity" {
  title = "電気"
}

resource "grafana_folder" "finance" {
  title = "金銭"
}

resource "grafana_folder" "healthcare" {
  title = "健康"
}

resource "grafana_folder" "misc" {
  title = "その他パーツ類"
}

resource "grafana_folder" "network" {
  title = "ネットワーク"
}

resource "grafana_folder" "onair" {
  title = "放送"
}

resource "grafana_folder" "rss" {
  title = "RSS"
}

resource "grafana_folder" "todolist" {
  title = "TODOリスト"
}
