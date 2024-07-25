locals {
  app_name    = "hrportal"
}

variable "aws_profile" {
  description = "sso"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate ARN variable"
  type        = string
}

variable "frontend_domain_name"{
  type        = string
}

#variable "backend_domain_name"{
#  type        = string
#}

variable "domain_name" {
  type        = string
}

#variable "zone_id" {
#  type        = string
#}

#variable "username" {
#  type = list(string)
#  default = ["hrportal-servicio-${terraform.workspace}"]
#}

variable "username" {
  type        = string
}



