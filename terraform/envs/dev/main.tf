module "lambda" {
  source                       = "../../modules/lambda"
  service_name                 = "sns-to-telegram-dev"
  topic_name                   = "telegram-notifications-dev"
  ssm_param_lambda_image_uri   = var.ssm_param_lambda_image_uri
  ssm_param_telegram_bot_token = var.ssm_param_telegram_bot_token
  ssm_param_telegram_chat_id   = var.ssm_param_telegram_chat_id
}
