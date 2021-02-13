resource "google_vpc_access_connector" "backend" {
  name          = "backend-vpc-connector"
  ip_cidr_range = google_compute_global_address.postgress_sql.address
  network       = "default"
}

resource "google_cloudfunctions_function" "backend" {
  name        = "backend"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  trigger_http          = true
  vpc_connector         = google_vpc_access_connector.backend.id

  environment_variables = {
    DATABASE_URL = "postgresql://${google_sql_user.backend_user.name}:${var.db_password}@${google_sql_database_instance.postgres.private_ip_address}:5432/${google_sql_database.backend.name}"
  }
}

resource "google_compute_region_network_endpoint_group" "backend" {
  name                  = "backend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_function {
    function = google_cloudfunctions_function.backend.name
  }
}

resource "google_compute_backend_service" "backend" {
  name = "backend-service"
  backend {
    group = google_compute_region_network_endpoint_group.backend.name
  }
}
