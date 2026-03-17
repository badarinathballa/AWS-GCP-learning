module "gcs" {
  source = "./modules/gcs"
  bucket_name = var.gcs_bucket_name
  region      = var.gcp_region
  environment = var.environment
}


# ─── SECRETS MODULE ────────────────────────────────────
module "secrets" {
  source = "./modules/secrets"
  environment             = var.environment
  gcp_service_account_key = module.gcs.service_account_key
}


# ─── DYNAMODB MODULE ───────────────────────────────────
module "dynamodb" {
  source = "./modules/dynamodb"

  table_name  = var.dynamodb_table_name
  environment = var.environment
}


# ─── SQS MODULE ────────────────────────────────────────
module "sqs" {
  source = "./modules/sqs"

  environment = var.environment
}


# ─── IAM MODULE ────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  environment = var.environment
  queue_arn   = module.sqs.queue_arn
  secret_arn  = module.secrets.secret_arn
}


# ─── LAMBDA MODULE ─────────────────────────────────────
module "lambda" {
  source = "./modules/lambda"

  environment      = var.environment
  lambda1_role_arn = module.iam.lambda1_role_arn
  lambda2_role_arn = module.iam.lambda2_role_arn
  stream_arn       = module.dynamodb.stream_arn
  queue_arn        = module.sqs.queue_arn
  queue_url        = module.sqs.queue_url
  secret_name      = module.secrets.secret_name
  gcs_bucket_name  = module.gcs.bucket_name
  aws_region       = var.aws_region
}