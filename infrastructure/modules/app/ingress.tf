
# https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#gcloud

# FIXME - fronend link
resource "google_compute_url_map" "frontend" {
  name = "ingress-url-map"
  default_service = google_compute_backend_bucket.frontend.self_link
}

# This would ideally be google_compute_target_https_proxy
resource "google_compute_target_http_proxy" "frontend" {
  name = "ingress-target-proxy"
  url_map = google_compute_url_map.frontend.self_link
}

resource "google_compute_global_address" "ingress" {
  name = "ingress-ip"
}

resource "google_compute_global_forwarding_rule" "frontend" {
  name = "ingress-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.frontend.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.frontend.self_link
}

# Self-signed certificates
# FIXME - load from disk https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#gcloud