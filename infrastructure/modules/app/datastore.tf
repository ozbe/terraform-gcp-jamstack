resource "google_compute_global_address" "postgress_sql" {
  name          = "postgres-sql-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network_id
}

resource "google_service_networking_connection" "postgres_sql" {
  network                 = var.private_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.postgress_sql.name]
}

resource "google_sql_database_instance" "postgres" {
  name   = "postgres"
  database_version = "POSTGRES_10"
  deletion_protection = var.deletion_protection

  depends_on = [google_service_networking_connection.postgres_sql]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network_id
    }
  }
}

resource "google_sql_database" "backend" {
  name     = "backend"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "backend_user" {
  name     = "backend"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

# grant user permissions
# https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs
