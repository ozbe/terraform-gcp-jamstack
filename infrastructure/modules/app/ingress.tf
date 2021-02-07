resource "google_compute_url_map" "ingress" {
  name = "ingress-url-map"

  host_rule {
    hosts = ["*"]
    path_matcher = "assets"
  }

  path_matcher {
    name = "assets"
    default_service = google_compute_backend_bucket.frontend.id
  }

  default_service = google_compute_backend_service.backend.id
}

# This would ideally be google_compute_target_https_proxy
# https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#gcloud
resource "google_compute_target_http_proxy" "ingress" {
  name = "ingress-target-proxy"
  url_map = google_compute_url_map.ingress.self_link
}

resource "google_compute_global_address" "ingress" {
  name = "ingress-ip"
}

resource "google_compute_global_forwarding_rule" "ingress" {
  name = "ingress-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.ingress.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.ingress.self_link
}

# Self-signed certificates
# FIXME - load from disk https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs#gcloud