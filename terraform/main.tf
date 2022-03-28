variable "prefix" {
  type    = string
  default = "tom"
}

variable "location" {
  type    = string
  default = "eastus2"
}

module "sharedEnvironment" {
  source   = "./modules/sharedEnvironment"
  prefix   = var.prefix
  location = var.location
}

module "subscriptions" {
  source           = "./modules/subscription"
  for_each         = fileset(path.module, "subscriptions/*.yaml")
  prefix           = var.prefix
  name             = yamldecode(file(each.value)).name
  vnetRange        = yamldecode(file(each.value)).vnetRange
  vwanHubId        = module.sharedEnvironment.vwanHubId
  vwanRouteId      = module.sharedEnvironment.vwanRouteId
  tags             = yamldecode(file(each.value)).tags
  owners           = yamldecode(file(each.value)).owners
  bastionVnetId    = module.sharedEnvironment.bastionVnetId
  bastionVnetName  = module.sharedEnvironment.bastionVnetName
  bastionRgName    = module.sharedEnvironment.bastionRgName
  location         = var.location
  privateDnsRgName = module.sharedEnvironment.privateDnsRgName
  privateDnsSet    = module.sharedEnvironment.privateDnsSet
}
