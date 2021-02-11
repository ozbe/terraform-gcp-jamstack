// backend bucket name
// cloud sql connections info

output "frontend_bucket" {
  value = google_storage_bucket.frontend.name
}

output "ingress_ip" {
  value = google_compute_global_address.ingress.address
}