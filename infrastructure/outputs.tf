output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "frontend_bucket" {
  value       = module.app.cdn_bucket_name
  description = "Name of public bucker to write frontend assets"
}

output "ingress_ip" {
  value       = module.app.cdn_ip
  description = "Ingress endpoint"
}