resource "aws_cloudtrail" "cloudtrail_trail" {
  depends_on = [aws_s3_bucket_policy.cloudtrail_bucket_policy]

  name                          = var.cloudtrail_trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = false
  kms_key_id                    = null

  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com", "rdsdata.amazonaws.com"]
  }

  sns_topic_name = aws_sns_topic.cloudtrail_sns_topic.name
}