module "network" {
  source = "./modules/network"
}

module "app" {
  source = "./modules/app"

  project_name       = data.google_project.project.name
  region             = var.region
  private_network_id = module.network.private_network_id
}