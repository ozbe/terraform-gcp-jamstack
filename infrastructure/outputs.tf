output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

# output "frontend_bucket" {
#   value       = module.app.frontend_bucket
#   description = "Name of public bucker to write frontend assets"
# }

# output "ingress_ip" {
#   value       = module.app.ingress_ip
#   description = "Ingress endpoint"
# }

output "app_db_instance_connect_name" {
  value = module.app.db_instance_connect_name
}

output "app_db_name" {
  value = module.app.db_name
}

output "app_db_user" {
  value = module.app.db_user
}