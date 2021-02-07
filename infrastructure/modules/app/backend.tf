resource "google_storage_bucket" "backend" {
  name = "${var.project_name}-backend"
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector
// for cloud sql

# Serverless VPC Access connector
# https://cloud.google.com/functions/docs/networking/connecting-vpc#configuring
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector
resource "google_vpc_access_connector" "backend" {
  name          = "backend-vpc-connector"
  ip_cidr_range = google_compute_global_address.postgress_sql.address
  network       = "default"
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function
resource "google_cloudfunctions_function" "backend" {
  name        = "backend"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.backend.name
  source_archive_object = "index.zip"
  trigger_http          = true
  entry_point           = "handler"
  vpc_connector = google_vpc_access_connector.backend.id

  environment_variables = {
    DATABASE_URL = "postgresql://${google_sql_user.backend_user.name}:${random_password.backend_sql_password.result}@${google_sql_database_instance.postgres.private_ip_address}:5432/${google_sql_database.backend.name}"
  }
}

# https://cloud.google.com/load-balancing/docs/https/setting-up-https-serverless#gcloud:-cloud-functions
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoint_group
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
