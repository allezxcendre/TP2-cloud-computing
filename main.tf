provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


resource "azurerm_resource_group" "rg" {
  name     = "wordpress-${var.environment}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "wpacr${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysql-${var.environment}-2025-martin"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "mysqladmin"
  administrator_password = var.mysql_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  zone                   = "1"
  delegated_subnet_id    = null
}

resource "azurerm_linux_web_app" "wordpress" {
  name                = "wordpress-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/wordpress-custom:latest"
  }

  app_settings = {
    WEBSITES_PORT                     = "80"
    DOCKER_REGISTRY_SERVER_URL       = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME  = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD  = azurerm_container_registry.acr.admin_password
    WORDPRESS_DB_HOST                = azurerm_mysql_flexible_server.mysql.fqdn
    WORDPRESS_DB_USER                = "mysqladmin@mysql-${var.environment}"
    WORDPRESS_DB_PASSWORD            = var.mysql_password
  }
}

resource "azurerm_service_plan" "sp" {
  name                = "plan-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}
