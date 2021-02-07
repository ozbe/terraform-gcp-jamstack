variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "australia-southeast1"
}

variable "services" {
  type        = list(string)
  description = "Project services to manage by terraform"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}