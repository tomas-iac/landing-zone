variable "prefix" {
  type = string
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "name" {
  type = string
}

variable "vnetRange" {
  type = string
}

variable "vwanHubId" {
  type = string
}

variable "vwanRouteId" {
  type = string
}

variable "bastionVnetName" {
  type = string
}

variable "bastionVnetId" {
  type = string
}

variable "bastionRgName" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "owners" {
  type = list(string)
}