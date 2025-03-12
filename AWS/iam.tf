# User
resource "aws_iam_user" "splunk_user" {
  name = var.splunk_iam_user
}

# Create access key
resource "aws_iam_access_key" "splunk_user_key" {
  user = aws_iam_user.splunk_user.name
}

# Create policy
data "aws_iam_policy_document" "splunk_policy" {
  statement {
    sid    = "S3"
    effect = "Allow"
    actions = ["s3:GetObject",
      "s3:GetObjectVersion",
    "s3:GetBucketLocation"]
    resources = ["${aws_s3_bucket.cloudtrail_bucket.arn}",
    "${aws_s3_bucket.cloudtrail_bucket.arn}/*"]
  }

  statement {
    sid    = "SQSqueue"
    effect = "Allow"
    actions = ["sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueAttributes"]
    resources = ["${aws_sqs_queue.cloudtrail_splunk_queue.arn}",
    "${aws_sqs_queue.cloudtrail_splunk_deadletter.arn}"]
  }

    statement {
    sid    = "SQSGlobal"
    effect = "Allow"
    actions = ["sqs:ListQueues"]
    resources = ["*"]
  }
}

# Attribute policy
resource "aws_iam_user_policy" "splunk_user_policy" {
  name   = var.splunk_iam_policy
  user   = aws_iam_user.splunk_user.name
  policy = data.aws_iam_policy_document.splunk_policy.json
}