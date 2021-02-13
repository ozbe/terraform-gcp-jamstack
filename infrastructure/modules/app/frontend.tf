resource "google_storage_bucket" "frontend" {
  name = "${var.project_name}-frontend"
  force_destroy = !var.deletion_protection
}

resource "google_storage_default_object_access_control" "frontend_read" {
  bucket = google_storage_bucket.frontend.name
  role = "READER"
  entity = "allUsers"
}

resource "google_compute_backend_bucket" "frontend" {
  name = "static-assets-backend"
  bucket_name = google_storage_bucket.frontend.name
  enable_cdn = true
}
