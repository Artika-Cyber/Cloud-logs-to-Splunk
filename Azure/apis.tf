data "azurerm_managed_api" "managed_api_eventhub" {
  name     = "eventhubs"
  location = var.region
}

resource "azapi_resource" "eventhub_api_connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = var.eventhub_api_connection
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  body = {
    properties = {
      api = {
        id = data.azurerm_managed_api.managed_api_eventhub.id
      }
      displayName = var.eventhub_api_connection
      parameterValueSet = {
        name = "managedIdentityAuth"
        values = {
          namespaceEndpoint = {
            value = "sb://${var.eh_namespace}.servicebus.windows.net/"
          }
        }
      }
    }
  }
  schema_validation_enabled = false
}

data "azurerm_managed_api" "managed_api_storage" {
  name     = "azureblob"
  location = var.region
}

resource "azapi_resource" "storage_api_connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = var.storage_api_connection
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  body = {
    properties = {
      api = {
        id = data.azurerm_managed_api.managed_api_storage.id
      }
      displayName = var.storage_api_connection
      parameterValueSet = {
        name = "managedIdentityAuth"
      }
    }
  }
  schema_validation_enabled = false
}

data "azurerm_managed_api" "managed_api_monitor" {
  name     = "azuremonitorlogs"
  location = var.region
}

resource "azapi_resource" "monitor_api_connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = var.monitor_api_connection
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  body = {
    properties = {
      api = {
        id = data.azurerm_managed_api.managed_api_monitor.id
      }
      displayName = var.monitor_api_connection
      parameterValueSet = {
        name = "managedIdentityAuth"
      }
    }
  }
  schema_validation_enabled = false
}