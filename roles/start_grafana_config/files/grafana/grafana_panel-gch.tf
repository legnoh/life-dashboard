resource "grafana_library_panel" "gch" {
  count      = length(var.GCH_STREAMS)
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.onair.uid
  name       = "GREEN Ch.(${var.GCH_STREAMS[count.index].channel_id})"
  model_json = jsonencode({
    title       = var.GCH_STREAMS[count.index].program_name,
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = true,
      videoType = "iframe",
      iframeURL = "http://grafstation.local/player/hls.html?url=${urlencode(var.GCH_STREAMS[0].stream_url)}",
    },
  })
}

resource "grafana_library_panel" "gch_not_onair" {
  org_id     = grafana_organization.main.org_id
  folder_uid = grafana_folder.onair.uid
  name       = "GREEN Ch.(not onair)"
  model_json = jsonencode({
    title       = "放送休止",
    type        = "innius-video-panel",
    transparent = true,
    options = {
      autoPlay  = false,
      videoType = "url",
    },
  })
}
