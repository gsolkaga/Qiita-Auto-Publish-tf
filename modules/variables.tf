variable "tags" {
  description = "モジュール内の全作成リソースに付与するタグ"
  default     = {}
  type        = map(string)
}

variable "prefix" {
  description = "作成するリソース名の先頭を指定する"
  default     = "QAP_"
  type        = string
}

variable "token" {
  description = "Qiita設定変更用APIトークンを環境変数から設定する"
  default     = ""
  type        = string
}

variable "posting_date_utc" {
  description = "Qiita自動投稿の予定日時を設定する(UTC)"
  type = object({
    year  = number
    month = number
    day   = number
    hour  = number
    min   = number
  })
}

variable "article" {
  description = "Qiita自動投稿の記事内容を設定する"
  type = object({
    title        = string
    body         = string
    tags         = list(string)
    private_flag = optional(bool, true)
    organization = optional(string, null)
  })
}
