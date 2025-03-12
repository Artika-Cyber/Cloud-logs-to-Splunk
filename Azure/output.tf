# Output Storage Account Connection String
output "storacc_connection_string" {
  value       = azurerm_storage_account.storacc.primary_connection_string
  description = "The connection string for the Storage account"
  sensitive   = true
}

# Output Event Hub Connection String
data "azurerm_eventhub_authorization_rule" "eh_authorization_rule" {
  name                = azurerm_eventhub_authorization_rule.eh_authorization_rule.name
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_eventhub_sas" "eh_sas" {
  connection_string = data.azurerm_eventhub_authorization_rule.eh_authorization_rule.primary_connection_string
  expiry            = "2030-02-01T00:00:00Z"
}

output "eventhub_connection_string" {
  value       = data.azurerm_eventhub_sas.eh_sas.connection_string
  description = "The connection string for the Event Hub"
  sensitive   = true
}