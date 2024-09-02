provider "aws" {
  region = var.aws_region
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "e-learning-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "e-learning-cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = true
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
  
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "bsolz"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}

resource "aws_secretsmanager_secret" "e-learning-cognito-details" {
  name = "e-learning-cognito-details"
}

resource "aws_secretsmanager_secret_version" "e-learning-cognito-details-version" {
  secret_id = aws_secretsmanager_secret.e-learning-cognito-details.id
  secret_string = jsonencode({
    COGNITO_CLIENT_ID = var.cognito_client_id
    COGNITO_CLIENT_SECRET = var.cognito_client_secret
    COGNITO_USER_POOL_ID = var.cognito_user_pool_id
    COGNITO_ISSUER_URI = var.cognito_issuer_uri
  })
}

resource "aws_iam_policy" "e-learning-get-secret-policy" {
  name = var.iam_secret_manager_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "${var.secret_arn}"
      }
    ]
  })
}

resource "aws_iam_role" "e-learning-get-secret-role" {
  name = var.iam_secret_manager_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal =  { "AWS": "arn:aws:iam::${var.account_id}:role/${var.principal_role_name}" }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "e-learning-secret-policy-attachment" {
  name = "E-Learning Secret Manager Policy Attachement"
  policy_arn = aws_iam_policy.e-learning-get-secret-policy.arn
  roles       = [aws_iam_role.e-learning-get-secret-role.name]
}
