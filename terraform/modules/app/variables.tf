variable "service_name" {
  type        = string
  description = "Service name, also used to compose various AWS resource names"
  default     = "sns-to-telegram"
}

variable "service_description" {
  type        = string
  description = "Service description"
  default     = "Forward SNS events to Telegram"
}

variable "image_uri" {
  type        = string
  description = "Lambda image URI"
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

variable "topic_name" {
  type = string
  description = "SNS topic name"
  default = "telegram-notifications"
}
