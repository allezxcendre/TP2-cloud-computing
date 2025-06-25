output "webapp_url" {
  value = "https://${azurerm_linux_web_app.wordpress.default_hostname}"
}