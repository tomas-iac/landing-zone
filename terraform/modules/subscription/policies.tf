// DENY: creation of Public IP
resource "azurerm_policy_assignment" "denyResources" {
  name                 = "denyResources"
  scope                = azurerm_resource_group.envRg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  description          = "Not allowed resource types"
  display_name         = "denyResources"
  location             = var.location

  parameters = <<PARAMETERS
{
  "listOfResourceTypesNotAllowed": {
    "value": [
        "Microsoft.Network/publicIPAddresses"
    ]
  }
}
PARAMETERS

}

// AUDIT: Virtual machines should be protected with network security groups
resource "azurerm_policy_assignment" "audisNsg" {
  name                 = "audisNsg"
  scope                = azurerm_resource_group.envRg.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bb91dfba-c30d-4263-9add-9c2384e659a6"
  description          = "Virtual machines should be protected with network security groups"
  display_name         = "audisNsg"
  location             = var.location
}

// DENY: Only VNET ResourceID that can be created/updated must be the one deployed by this template, all others are denied
resource "azurerm_policy_definition" "denyOtherVnets" {
  name         = "denyOtherVnets"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "denyOtherVnets"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [
            {
                "field": "type",
                "equals": "Microsoft.Network/virtualNetworks"
            },
            {
                "value": "[field('type')]",
                "exists": true
            },
            {
                "field": "id",
                "notEquals": "[parameters('vnetId')]"
            }
        ]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "vnetId": {
      "type": "String",
      "metadata": {
        "description": "ID of only allowed VNET name (all other VNET creations will be denied)",
        "displayName": "VNET Resource ID"
      }
    }
  }
PARAMETERS

}

resource "azurerm_policy_assignment" "denyOtherVnets" {
  name                 = "denyOtherVnets"
  scope                = azurerm_resource_group.envRg.id
  policy_definition_id = azurerm_policy_definition.denyOtherVnets.id
  description          = "Only VNET ResourceID that can be created/updated must the one deployed by IT, all others are denied"
  display_name         = "denyOtherVnets"
  location             = azurerm_resource_group.envRg.location

  parameters = <<PARAMETERS
{
  "vnetId": {
    "value": "${azurerm_virtual_network.envVnet.id}"
  }
}
PARAMETERS

}

