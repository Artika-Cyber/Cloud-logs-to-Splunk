variable "aws_region" {
  default     = "eu-west-1"
  description = "AWS region for the resources"
}

variable "cloudtrail_bucket_name" {
  default     = "cloudtrail-s3-bucket-48647677867"
  description = "S3 bucket for storing CloudTrail logs"
}

variable "cloudtrail_trail_name" {
  default     = "splunk-trail"
  description = "CloudTrail name"
}

variable "splunk_iam_user" {
  default     = "splunk-user"
  description = "Splunk IAM user"
}

variable "splunk_iam_policy" {
  default     = "splunk-iam-policy"
  description = "Inline policy for Splunk user"
}

variable "sns_topic_name" {
  default     = "cloudtrail-sns-topic"
  description = "SNS topic for CloudTrail"
}

variable "sqs_cloudtrail_splunk_name" {
  default     = "cloudtrail-splunk-queue"
  description = "SQS queue name for CloudTrail"
}

variable "sqs_deadletter_cloudtrail_splunk_name" {
  default     = "cloudtrail-splunk-queue-deadletter"
  description = "DeadLetter SQS queue name for CloudTrail"
}