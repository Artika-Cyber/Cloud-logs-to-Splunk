# Cloud logs to Splunk
Terraform code for configuring logs forwarding from the Cloud to Splunk for different Cloud providers.

# Warning
For each provider, configure the variables you want.

# AWS
The code ships CloudTrail logs to a S3 and notifies an SNS to which is subscribed a SQS queue. The code outputs the key ID and secret needed to configure in Splunk.

# Azure
This code allows to create a Logic App which queries logs in a Log Analytics Workspace and ships them to an event hub. The code output the necessary items to configure in Splunk.
Configure the filter.txt file to extract only the logs needed.

# GCP
TODO
