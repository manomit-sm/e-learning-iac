variable "aws_region" {
  type = string
  description = "The region in which the resources will be created"
  default = "us-east-1"
}

variable "cognito_client_id" {
  type = string
}

variable "cognito_client_secret" {
  type = string
}

variable "cognito_issuer_uri" {
  type = string
}

variable "cognito_user_pool_id" {
  type = string
}