output "azurerm_linux_web_app_azurelwa_url" {
  description = "The URL of the Azure Linux Web App"
  value       = azurerm_linux_web_app.azurelwa.default_hostname

}