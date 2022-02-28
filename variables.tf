#resource groups

variable "resource_group_name_primary" {
  type = string
}

variable "location_primary" {
  type = string
}

variable "resource_group_name_secondary" {
  type = string
}

variable "location_secondary" {
  type = string
}

variable "resource_group_name_tm" {
  type = string
}

variable "location_tm" {
  type = string
}

#virtual networks

variable "network_name_primary" {
  type = string
}
#add variable network address space
variable "network_name_secondary" {
  type = string
}
#add variable network address space
variable "network_name_tm" {
  type = string
}
#add variable network address space

#primary vnet subnets

variable "managementsubnet1" {
  type = string
}
#add variable subnet space

variable "websubnet1" {
  type = string
}
#add variable subnet space

variable "businesssubnet1" {
  type = string
}
#add variable subnet space

variable "datasubnet1" {
  type = string
}
#add variable subnet space

variable "ADsubnet1" {
  type = string
}
#add variable subnet space

#secondary vnet subnets

variable "managementsubnet2" {
  type = string
}
#add variable subnet space

variable "websubnet2" {
  type = string
}
#add variable subnet space

variable "businesssubnet2" {
  type = string
}
#add variable subnet space

variable "datasubnet2" {
  type = string
}
#add variable subnet space

variable "ADsubnet2" {
  type = string
}
#add variable subnet space

#traffic manager vnet subnet
variable "trafficmanagersubnet" {
  type = string
}
#add variable subnet space

#virtual network peering
variable "primarytosecondary" {
  type = string
}

variable "secondarytoprimary" {
  type = string
}

#app service plans
variable "appserviceplan_primary" {
  type = string
}

variable "appserviceplan_secondary" {
  type = string
}

# app services
variable "appservice_primary" {
  type = string
}

variable "appservice_secondary" {
  type = string
}

# dynamic ip addresses
variable "pip_primary" {
  type = string
}

variable "pip_secondary" {
  type = string
}

# application gateway
variable "appgw_primary" {
  type = string
}

variable "appgw_secondary" {
  type = string
}

# traffic manager
variable "traffic_manager" {
  type = string
}

variable "tmendpoint_primary" {
  type = string
}

variable "tmendpoint_secondary" {
  type = string
}