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

variable "secret_arn" {
  type = string
}

variable "iam_secret_manager_policy_name" {
  type = string
  default = "e-learning-get-secret-policy"
}

variable "iam_secret_manager_role_name" {
  type = string
  default = "e-learning-get-secret-role"
}

variable "account_id" {
  type = string
}

variable "principal_role_name" {
  type = string
}