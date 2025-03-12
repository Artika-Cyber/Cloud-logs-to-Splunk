data "local_file" "logic_app" {
  filename = "${path.module}/workflow.json"
}

# Logic App deployment
resource "azurerm_resource_group_template_deployment" "logic_app_deployment" {
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"
  name                = var.la_deployment_name

  template_content = data.local_file.logic_app.content

  parameters_content = jsonencode({
    ### Global variables
    "logicapp_name" = { value = var.la_name }
    "location"      = { value = lower(replace(var.region, " ", "")) }

    ### For connections
    # New connections
    "connections_eventhubs_externalid"        = { value = azapi_resource.eventhub_api_connection.id }
    "connections_azuremonitorlogs_externalid" = { value = azapi_resource.monitor_api_connection.id }
    "connections_azureblob_externalid"        = { value = azapi_resource.storage_api_connection.id }
    # ManagedApis ID
    "connections_eventhubs_id"        = { value = data.azurerm_managed_api.managed_api_eventhub.id }
    "connections_azuremonitorlogs_id" = { value = data.azurerm_managed_api.managed_api_monitor.id }
    "connections_azureblob_id"        = { value = data.azurerm_managed_api.managed_api_storage.id }
    # Name
    "connections_eventhubs_name"        = { value = var.eventhub_api_connection }
    "connections_azureblob_name"        = { value = var.storage_api_connection }
    "connections_azuremonitorlogs_name" = { value = var.monitor_api_connection }

    ### Storage
    "storage_account_name"   = { value = var.storage_account_name }
    "storage_container_name" = { value = var.storage_account_container_name }
    "date_file_name"         = { value = var.date_blob_name }
    "filter_file_name"       = { value = var.filter_blob_name }
    # Weird metadata in workflow file
    "base64_date_file"   = { value = base64encode("%2f${var.storage_account_container_name}%2f${var.date_blob_name}") }
    "base64_filter_file" = { value = base64encode("%2f${var.storage_account_container_name}%2f${var.filter_blob_name}") }

    # Complex vars
    "url_path_date_file" = { value = "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${var.storage_account_name}'))}/files/@{encodeURIComponent(encodeURIComponent('${base64encode("%2f${var.storage_account_container_name}%2f${var.date_blob_name}")}'))}/content" }

    "url_path_date_file_post" = { value = "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${var.storage_account_name}'))}/files/@{encodeURIComponent(encodeURIComponent('${base64encode("%2f${var.storage_account_container_name}%2f${var.date_blob_name}")}'))}" }

    "url_path_filter_file" = { value = "/v2/datasets/@{encodeURIComponent(encodeURIComponent('${var.storage_account_name}'))}/files/@{encodeURIComponent(encodeURIComponent('${base64encode("%2f${var.storage_account_container_name}%2f${var.filter_blob_name}")}'))}/content" }

    "url_path_eventhub" = { value = "/@{encodeURIComponent('${var.eh_name}')}/events" }

    ### Log analytics information (for the prod log analytics)
    "la_subscription_id" = { value = var.log_analytics_subscription_id }
    "la_resource_group"  = { value = var.log_analytics_resource_group }
    "la_name"            = { value = var.log_analytics_name }
  })

  depends_on = [azapi_resource.eventhub_api_connection,
    azapi_resource.storage_api_connection,
    azapi_resource.monitor_api_connection,
    azurerm_storage_blob.filter_file,
    azurerm_storage_blob.date_file,
  azurerm_eventhub_consumer_group.eh_consumergroup]
}

data "azurerm_logic_app_workflow" "la" {
  name                = var.la_name
  resource_group_name = azurerm_resource_group_template_deployment.logic_app_deployment.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_data" {
  name                = var.log_analytics_name
  resource_group_name = var.log_analytics_resource_group
}

# Permissions for the Logic App
resource "azurerm_role_assignment" "logic_app_storage_write" {
  principal_id         = data.azurerm_logic_app_workflow.la.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.storacc.id
}

resource "azurerm_role_assignment" "logic_app_eventhub_send" {
  principal_id         = data.azurerm_logic_app_workflow.la.identity[0].principal_id
  role_definition_name = "Azure Event Hubs Data Sender"
  scope                = azurerm_eventhub.eh.id
}

resource "azurerm_role_assignment" "logic_app_loganalytics_read" {
  principal_id         = data.azurerm_logic_app_workflow.la.identity[0].principal_id
  role_definition_name = "Log Analytics Reader"
  scope                = data.azurerm_log_analytics_workspace.log_analytics_data.id
}