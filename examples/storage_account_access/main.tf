resource "azurerm_resource_group" "terraform" {
  name     = "rg-storageaccount-access"
  location = "West Europe"
}

resource "azurerm_storage_account" "publicsa" {
  name                          = "stpubanonymous"
  resource_group_name           = azurerm_resource_group.terraform.name
  location                      = azurerm_resource_group.terraform.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "publicsa-storage-container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.publicsa.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "privateauth" {
  name                          = "stpubaccess"
  resource_group_name           = azurerm_resource_group.terraform.name
  location                      = azurerm_resource_group.terraform.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "privateauth-storage-container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.privateauth.name
  container_access_type = "private"
}