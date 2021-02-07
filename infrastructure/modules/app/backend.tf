resource "google_storage_bucket" "backend" {
  name = "${var.project_name}-backend"
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector
// for cloud sql

# Serverless VPC Access connector
# https://cloud.google.com/functions/docs/networking/connecting-vpc#configuring
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector
resource "google_vpc_access_connector" "backend" {
  name          = "vpc-con"
  ip_cidr_range = "10.8.0.0/28" // FIXME - use cloudsql
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
  entry_point           = "helloGET" # FIXME
  vpc_connector = google_vpc_access_connector.backend

  # environment_variables = {
  #   MY_ENV_VAR = "my-env-var-value"
  # }
}


# https://cloud.google.com/load-balancing/docs/https/setting-up-https-serverless#gcloud:-cloud-functions

# google_compute_network_endpoint_group
# gcloud compute network-endpoint-groups create SERVERLESS_NEG_NAME \
#     --region=us-central1 \
#     --network-endpoint-type=serverless  \
#     --cloud-run-service=CLOUD_RUN_SERVICE_NAME

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoint_group
resource "google_compute_region_network_endpoint_group" "backend" {
  name                  = "backend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1" # FIXME - region

  cloud_function {
    function = google_cloudfunctions_function.backend.name
  }
}

# gcloud compute backend-services create BACKEND_SERVICE_NAME \
    # --global

# gcloud compute backend-services add-backend BACKEND_SERVICE_NAME \
#     --global \
#     --network-endpoint-group=SERVERLESS_NEG_NAME \
#     --network-endpoint-group-region=us-central1

resource "google_compute_backend_service" "backend" {
  name = "backend-service"
  backend {
    group = google_compute_region_network_endpoint_group.backend.name
  }
}

# TODO - connect to url map

# db secret https://dev.to/googlecloud/using-secrets-in-google-cloud-functions-5aem
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret