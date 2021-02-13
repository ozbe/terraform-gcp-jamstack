module "network" {
  source = "./modules/network"

  project_name = data.google_project.project.name

  depends_on = [
    google_project_service.services
  ]
}

module "app" {
  source = "./modules/app"

  project_name        = data.google_project.project.name
  region              = var.region
  private_network_id  = module.network.private_network_id
  deletion_protection = var.deletion_protection
  db_password         = var.app_db_password

  depends_on = [
    google_project_service.services
  ]
}