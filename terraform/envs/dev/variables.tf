variable "image_lambda" {
  type = string
}

variable "ssm_param_telegram_bot_token" {
  type        = string
  description = "Name of the SSM parameter storing the Telegram Bot API token"
  default     = "/telegram/token"
}

variable "ssm_param_telegram_chat_id" {
  type        = string
  description = "Name of the SSM parameter storing the Telegram chat ID"
  default     = "/telegram/chat-id"
}
