variable "ssm_param_telegram_bot_token" {
  type        = string
  description = "Name of the SSM parameter storing the Telegram Bot API token"
}

variable "ssm_param_telegram_chat_id" {
  type        = string
  description = "Name of the SSM parameter storing the Telegram chat ID"
}

variable "ssm_param_lambda_image_uri" {
  type        = string
  description = "Name of the SSM parameter storing the lambda image URI"
}
