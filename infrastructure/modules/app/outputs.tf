// backend bucket name

output "frontend_bucket" {
  value = google_storage_bucket.frontend.name
}

output "ingress_ip" {
  value = google_compute_global_address.ingress.address
}

output "db_instance_connect_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "db_name" {
  value = google_sql_database.backend.name
}

output "db_user" {
  value = google_sql_user.backend_user.name
}
