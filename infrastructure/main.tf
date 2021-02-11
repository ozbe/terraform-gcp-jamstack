module "network" {
  source = "./modules/network"

  project_name       = data.google_project.project.name

  depends_on = [
    google_project_service.services
  ]
}

module "app" {
  source = "./modules/app"

  project_name       = data.google_project.project.name
  region             = var.region
  private_network_id = module.network.private_network_id

  depends_on = [
    google_project_service.services
  ]
}