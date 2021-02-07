# https://cloud.google.com/functions/docs/calling/http

resource "google_project_service" "services" {
  count              = length(var.services)
  service            = element(var.services, count.index)
  disable_on_destroy = false
}