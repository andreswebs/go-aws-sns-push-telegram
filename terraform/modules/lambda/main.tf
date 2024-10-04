data "aws_ssm_parameter" "telegram_bot_token" {
  name            = var.ssm_param_telegram_bot_token
  with_decryption = true
}

data "aws_ssm_parameter" "telegram_chat_id" {
  name            = var.ssm_param_telegram_chat_id
  with_decryption = true
}

data "aws_ssm_parameter" "lambda_image_uri" {
  with_decryption = true
  name            = var.ssm_param_lambda_image_uri
}

locals {
  lambda_env = {
    TELEGRAM_BOT_TOKEN = data.aws_ssm_parameter.telegram_bot_token.value
    TELEGRAM_CHAT_ID   = data.aws_ssm_parameter.telegram_chat_id.value
  }

  lambda_alias = "default"

  lambda_image_uri = data.aws_ssm_parameter.lambda_image_uri.value
}


module "lambda_base" {
  source  = "andreswebs/lambda-base/aws"
  version = "0.3.0"
  name    = var.service_name
}

module "lambda" {
  depends_on                 = [module.lambda_base]
  source                     = "terraform-aws-modules/lambda/aws"
  function_name              = var.service_name
  description                = var.service_description
  image_uri                  = local.lambda_image_uri
  create_lambda_function_url = false
  create_role                = false
  create_package             = false
  environment_variables      = local.lambda_env
  lambda_role                = module.lambda_base.iam_role.arn
  package_type               = "Image"
  publish                    = true
  memory_size                = 256
  timeout                    = 60

  architectures = ["arm64"]

  use_existing_cloudwatch_log_group = true
}

module "alias" {
  depends_on       = [module.lambda]
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias    = true
  name             = local.lambda_alias
  function_name    = module.lambda.lambda_function_name
  function_version = module.lambda.lambda_function_version
}

module "deploy" {
  source         = "terraform-aws-modules/lambda/aws//modules/deploy"
  depends_on     = [module.alias]
  alias_name     = module.alias.lambda_alias_name
  function_name  = module.lambda.lambda_function_name
  target_version = module.lambda.lambda_function_version

  create_app = true
  app_name   = var.service_name

  create_deployment_group    = true
  deployment_group_name      = local.lambda_alias
  create_deployment          = true
  run_deployment             = true
  save_deploy_script         = false
  wait_deployment_completion = true

  force_deploy = true
}
