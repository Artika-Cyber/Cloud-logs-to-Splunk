resource "aws_sns_topic" "cloudtrail_sns_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.cloudtrail_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sqs_queue" "cloudtrail_splunk_queue" {
  name                       = var.sqs_cloudtrail_splunk_name
  message_retention_seconds  = 604800
  visibility_timeout_seconds = 300
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cloudtrail_splunk_deadletter.arn
    maxReceiveCount     = 5
  })
}

resource "aws_sqs_queue" "cloudtrail_splunk_deadletter" {
  name = var.sqs_deadletter_cloudtrail_splunk_name
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.cloudtrail_splunk_queue.id
  policy    = data.aws_iam_policy_document.queue_policy.json
}

data "aws_iam_policy_document" "queue_policy" {
  statement {
    sid    = "AllowSNSWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.cloudtrail_splunk_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.cloudtrail_sns_topic.arn]
    }
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AllowSNSPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cloudtrail_sns_topic.arn]
  }
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.cloudtrail_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.cloudtrail_splunk_queue.arn
}