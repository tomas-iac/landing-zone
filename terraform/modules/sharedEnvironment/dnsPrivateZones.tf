locals {
  privatezones = toset([
    "privatelink.azure-automation.net",
    "privatelink.database.windows.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
    "privatelink.azuresynapse.net",
    "privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.web.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.esteurope.batch.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.westeurope.azmk8s.io",
    "privatelink.search.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azconfig.io",
    "privatelink.westeurope.backup.windowsazure.com",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azure-devices.net",
    "privatelink.servicebus.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.azurewebsites.net",
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.service.signalr.net",
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.afs.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.digitaltwins.azure.net",
    "privatelink.azurehdinsight.net",
  ])
}

// DNS resource group
resource "azurerm_resource_group" "dnsRg" {
  name     = "${var.prefix}-dns-rg"
  location = var.location
}

// Private zones
resource "azurerm_private_dns_zone" "privaendpoints" {
  for_each            = local.privatezones
  name                = each.key
  resource_group_name = azurerm_resource_group.dnsRg.name
}
