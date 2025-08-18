resource "aws_iam_role" "this" {
  name               = "${var.prefix}QiitaEventBridgeRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(var.tags, local.additional_tags)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.prefix}QiitaEventBridgePolicy"
  policy = data.aws_iam_policy_document.this.json
  tags   = merge(var.tags, local.additional_tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = ["events:InvokeApiDestination"]
    resources = [aws_cloudwatch_event_api_destination.this.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.this.arn]
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

