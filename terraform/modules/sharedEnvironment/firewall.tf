// Firewall
resource "azurerm_firewall_policy" "vwan" {
  name                = "${var.prefix}-fw-policy"
  resource_group_name = azurerm_resource_group.vwanRg.name
  location            = azurerm_resource_group.vwanRg.location
}

resource "azurerm_firewall" "vwan" {
  name                = "${var.prefix}-fw"
  location            = azurerm_resource_group.vwanRg.location
  resource_group_name = azurerm_resource_group.vwanRg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.vwan.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vwan.id
    public_ip_count = 1
  }
}

// Outbound FQDNs for environments
resource "azurerm_firewall_policy_rule_collection_group" "outboundFqdns" {
  name               = "outboundFqdns"
  firewall_policy_id = azurerm_firewall_policy.vwan.id
  priority           = 200

  dynamic "application_rule_collection" {
    for_each = fileset(path.module, "subscriptions/*.yaml")
    content {

      name     = yamldecode(file(application_rule_collection.value)).name
      priority = yamldecode(file(application_rule_collection.value)).fwPriority
      action   = "Allow"

      dynamic "rule" {
        for_each = yamldecode(file(application_rule_collection.value)).outboundFqdns
        content {
          name = rule.value.name

          source_ip_groups = [
            azurerm_ip_group.vwan[yamldecode(file(application_rule_collection.value)).name].id
          ]

          destination_fqdns = rule.value.fqdns

          protocols {
            port = "443"
            type = "Https"
          }
        }
      }
    }
  }
}

// Common outbound FQDNs
resource "azurerm_firewall_policy_rule_collection_group" "commonFqdns" {
  name               = "commonFqdns"
  firewall_policy_id = azurerm_firewall_policy.vwan.id
  priority           = 100

  application_rule_collection {
    name     = "commonFqdns"
    priority = 100
    action   = "Allow"

    rule {
      name = "AzureTags"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdn_tags = [
        "AzureBackup",
        "AzureKubernetesService",
        "HDInsight",
        "MicrosoftActiveProtectionService",
        "WindowsDiagnostics",
        "WindowsUpdate",
      ]
    }

    rule {
      name = "tomaskubicacz"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "tomaskubica.cz",
        "*.tomaskubica.cz",
      ]
    }

    rule {
      name = "Ubuntu"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "ubuntu.com",
        "*.ubuntu.com",
      ]
    }

    rule {
      name = "Github"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "github.com",
        "*.github.com",
        "*.github.io",
        "*.githubusercontent.com"
      ]
    }

    rule {
      name = "GitOps"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "*.dp.kubernetesconfiguration.azure.com",
      ]
    }

    rule {
      name = "ARM"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "management.azure.com",
      ]
    }

    rule {
      name = "aka.ms"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "aka.ms",
      ]
    }

    rule {
      name = "repos"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]

      destination_fqdns = [
        "azurecliprod.blob.core.windows.net",
        "packages.microsoft.com",
        "dl.k8s.io",
        "storage.googleapis.com",
        "charts.jetstack.io",
        "quay.io",
        "*.quay.io",
        "k8s.gcr.io",
        "ghcr.io",
      ]
    }
  }
}

// Jump server access
resource "azurerm_firewall_policy_rule_collection_group" "jump" {
  name               = "jump"
  firewall_policy_id = azurerm_firewall_policy.vwan.id
  priority           = 101

  network_rule_collection {
    name     = "portsFromJump"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "management"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.244.0.0/16"]
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["80", "443", "22", "3389"]
    }
  }
}

