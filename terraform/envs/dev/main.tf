module "app" {
  source = "../../modules/app"
  service_name = "sns-to-telegram-dev"
  topic_name = "telegram-notifications-dev"
  image_uri = var.image_lambda
  ssm_param_telegram_bot_token = var.ssm_param_telegram_bot_token
  ssm_param_telegram_chat_id = var.ssm_param_telegram_chat_id
}
