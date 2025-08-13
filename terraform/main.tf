terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.39.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "092a8a8e-cac9-46cb-9f98-fdcdab2d54e3"
}

# web app resource group
resource "azurerm_resource_group" "azurerg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "azuresp" {
  name                = "BazarServicePlan"
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "azurelwa" {
  name                = "softunibazarkristinexample"
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_service_plan.azuresp.location
  service_plan_id     = azurerm_service_plan.azuresp.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.azurems.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.azuremd.name};User ID=${azurerm_mssql_server.azurems.administrator_login};Password=${azurerm_mssql_server.azurems.administrator_login};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}


# database resource group
resource "azurerm_mssql_server" "azurems" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.azurerg.name
  location                     = azurerm_resource_group.azurerg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "azuremd" {
  name           = "bazardatabase-1"
  server_id      = azurerm_mssql_server.azurems.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false

}


# firewall rull
resource "azurerm_mssql_firewall_rule" "firewallrule" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.azurems.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


# app service control - github
resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.azurelwa.id
  repo_url               = "https://github.com/kristindyulgeryan/Terraform-Deploy-SoftUniBazar"
  branch                 = "main"
  use_manual_integration = true
}

# do in terminal terraform fmt 
# terraform validate
# terraform plan
# and the End terraform plan -var-file="values.tfvars"