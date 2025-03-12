resource "azurerm_eventhub_namespace" "eh_namespace" {
  name                = var.eh_namespace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.eh_sku
}

resource "azurerm_eventhub" "eh" {
  name              = var.eh_name
  namespace_id      = azurerm_eventhub_namespace.eh_namespace.id
  partition_count   = 2
  message_retention = 7
}

resource "azurerm_eventhub_consumer_group" "eh_consumergroup" {
  name                = var.eh_consumergroup_name
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Create access key
resource "azurerm_eventhub_authorization_rule" "eh_authorization_rule" {
  name                = var.eh_authorization_rule
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = true
  send   = false
  manage = false
}