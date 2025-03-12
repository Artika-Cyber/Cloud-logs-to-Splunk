resource "azurerm_storage_account" "storacc" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storcont" {
  name                  = var.storage_account_container_name
  storage_account_id    = azurerm_storage_account.storacc.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "date_file" {
  name                   = var.date_blob_name
  storage_account_name   = azurerm_storage_account.storacc.name
  storage_container_name = azurerm_storage_container.storcont.name
  type                   = "Block"
  source_content         = timestamp()
}

resource "azurerm_storage_blob" "filter_file" {
  name                   = var.filter_blob_name
  storage_account_name   = azurerm_storage_account.storacc.name
  storage_container_name = azurerm_storage_container.storcont.name
  type                   = "Block"
  source                 = "./filter.txt"
}