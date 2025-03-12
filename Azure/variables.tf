variable "subscription_id" {
  default     = "guid-guid-guid-guid"
  description = "Subscription id"
}

variable "rg_name" {
  default     = "soc-logs-export"
  description = "Name of the resource group for logs export to SOC"
}

variable "la_name" {
  default     = "soc-logs-export-la"
  description = "Name of the Logic App for logs export to SOC"
}

variable "la_deployment_name" {
  default     = "soc-logs-export-la-deployment"
  description = "Name of the Logic App Deployment for logs export to SOC"
}

variable "region" {
  default     = "North Europe"
  description = "Region for the resources"
}

variable "eh_namespace" {
  default     = "soc-eh-namespace"
  description = "Namespace for the Event Hub"
}

variable "eh_sku" {
  default     = "Standard"
  description = "SKU for the Event Hub"
}

variable "eh_name" {
  default     = "soc-logs-export-eh"
  description = "Event Hub name"
}

variable "eh_consumergroup_name" {
  default     = "soc-logs-export-eh-cg"
  description = "Event Hub name"
}

variable "storage_account_name" {
  default     = "storaccsoc2"
  description = "Storage account name"
}

variable "storage_account_container_name" {
  default     = "storcontsoc"
  description = "Storage account container name"
}

variable "date_blob_name" {
  default     = "lastdate.txt"
  description = "Name of the file with the last date"
}

variable "filter_blob_name" {
  default     = "filter.txt"
  description = "Name of the file with the filters to apply"
}

variable "eh_authorization_rule" {
  default     = "soc"
  description = "Name for the access to the event hub"
}

variable "eventhub_api_connection" {
  default     = "eventhub-api-2"
  description = "API connection for Event Hub"
}

variable "storage_api_connection" {
  default     = "storage-api"
  description = "API connection for Storage"
}

variable "monitor_api_connection" {
  default     = "monitor-api"
  description = "API connection for Azure Monitor"
}

variable "log_analytics_subscription_id" {
  default     = "guid-guid-guid-guid"
  description = "Subscription ID for the log analytics"
}

variable "log_analytics_resource_group" {
  default     = "rg-la"
  description = "Resource group of the log analytics"
}

variable "log_analytics_name" {
  default     = "la-name"
  description = "Name of the log analytics"
}