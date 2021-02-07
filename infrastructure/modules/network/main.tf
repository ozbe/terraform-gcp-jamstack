resource "google_compute_network" "private_network" {
  provider = google-beta

  name = "private-network"
}