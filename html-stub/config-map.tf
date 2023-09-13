resource "kubernetes_config_map" "html_stub_volume" {
  metadata {
    name      = "html-stub-volume"
    namespace = var.namespace
  }

  data = {
    "index.html"  = base64decode("PGgxPlNVQ0NFU1M8L2gxPgo=")
  }
}
