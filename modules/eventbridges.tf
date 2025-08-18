resource "aws_cloudwatch_event_connection" "this" {
  name               = "${var.prefix}QiitaConnection"
  authorization_type = "API_KEY"
  auth_parameters {
    api_key {
      key   = "Authorization"
      value = "Bearer ${var.token}"
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "this" {
  name                             = "${var.prefix}QiitaApiDestination"
  connection_arn                   = aws_cloudwatch_event_connection.this.arn
  invocation_endpoint              = local.qiita_api_url
  http_method                      = "POST"
  invocation_rate_limit_per_second = 1
}

resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.prefix}QiitaApiScheduleRule"
  schedule_expression = "cron(${var.posting_date_utc.min} ${var.posting_date_utc.hour} ${var.posting_date_utc.day} ${var.posting_date_utc.month} ? ${var.posting_date_utc.year})"
}

resource "aws_cloudwatch_event_target" "this" {
  arn      = aws_cloudwatch_event_api_destination.this.arn
  role_arn = aws_iam_role.this.arn
  rule     = aws_cloudwatch_event_rule.this.name

  input = jsonencode({
    title                 = var.article.title
    body                  = var.article.body
    tags                  = [for i in var.article.tags : { name = i }]
    private               = var.article.private_flag
    organization_url_name = var.article.organization
  })

  dead_letter_config {
    arn = aws_sqs_queue.this.arn
  }
  retry_policy {
    maximum_event_age_in_seconds = 900
    maximum_retry_attempts       = 0
  }
  http_target {
    header_parameters       = {}
    path_parameter_values   = []
    query_string_parameters = {}
  }
}
