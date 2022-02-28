#resource groups
resource "azurerm_resource_group" "primary" {
  name     = var.resource_group_name_primary
  location = var.location_primary
}

resource "azurerm_resource_group" "secondary" {
  name     = var.resource_group_name_secondary
  location = var.location_secondary
}

resource "azurerm_resource_group" "trafficmanager" {
  name     = var.resource_group_name_tm
  location = var.location_tm
}

#virtual networks
resource "azurerm_virtual_network" "primarynet" {
  name                = var.network_name_primary
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
}

resource "azurerm_virtual_network" "secondarynet" {
  name                = var.network_name_secondary
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
}

resource "azurerm_virtual_network" "trafficmanager" {
  name                = var.network_name_tm
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.trafficmanager.location
  resource_group_name = azurerm_resource_group.trafficmanager.name
}

#primary vnet subnets
#primary vnet subnet- management
resource "azurerm_subnet" "managementsubnet1" {
  name                 = var.managementsubnet1
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#primary vnet subnet- web
resource "azurerm_subnet" "websubnet1" {
  name                 = var.websubnet1
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#primary vnet subnet- business
resource "azurerm_subnet" "businesssubnet1" {
  name                 = var.businesssubnet1
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.3.0/24"]
}

#primary vnet subnet- data
resource "azurerm_subnet" "datasubnet1" {
  name                 = var.datasubnet1
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.4.0/24"]
}

#primary vnet subnet- AD
resource "azurerm_subnet" "ADsubnet1" {
  name                 = var.ADsubnet1
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.5.0/24"]
}

#secondary vnet subnets
#secondary vnet subnet- management
resource "azurerm_subnet" "managementsubnet2" {
  name                 = var.managementsubnet2
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.1.0/24"]
}

#secondary vnet subnet- web
resource "azurerm_subnet" "websubnet2" {
  name                 = var.websubnet2
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.2.0/24"]
}

#secondary vnet subnet- business
resource "azurerm_subnet" "businesssubnet2" {
  name                 = var.businesssubnet2
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.3.0/24"]
}

#secondary vnet subnet- data
resource "azurerm_subnet" "datasubnet2" {
  name                 = var.datasubnet2
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.4.0/24"]
}

#secondary vnet subnet- AD
resource "azurerm_subnet" "ADsubnet2" {
  name                 = var.ADsubnet2
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.5.0/24"]
}

#traffic manager vnet subnet
resource "azurerm_subnet" "trafficmanagersubnet" {
  name                 = var.trafficmanagersubnet
  resource_group_name  = azurerm_resource_group.trafficmanager.name
  virtual_network_name = azurerm_virtual_network.trafficmanager.name
  address_prefixes     = ["10.2.1.0/24"]
}

#virtual network peering
resource "azurerm_virtual_network_peering" "primarytosecondary" {
  name                      = var.primarytosecondary
  resource_group_name       = azurerm_resource_group.primary.name
  virtual_network_name      = azurerm_virtual_network.primarynet.name
  remote_virtual_network_id = azurerm_virtual_network.secondarynet.id
}

resource "azurerm_virtual_network_peering" "secondarytoprimary" {
  name                      = var.secondarytoprimary
  resource_group_name       = azurerm_resource_group.secondary.name
  virtual_network_name      = azurerm_virtual_network.secondarynet.name
  remote_virtual_network_id = azurerm_virtual_network.primarynet.id
}

#app service plans
resource "azurerm_app_service_plan" "appserviceplan_primary" {
  name                = var.appserviceplan_primary
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service_plan" "appserviceplan_secondary" {
  name                = var.appserviceplan_secondary
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

# app services
resource "azurerm_app_service" "app-service-primary" {
  name                = var.appservice_primary
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan_primary.id
}

resource "azurerm_app_service" "app-service-secondary" {
  name                = var.appservice_secondary
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan_secondary.id
}

# dynamic ip addresses
resource "azurerm_public_ip" "pip_primary" {
  name                         = var.pip_primary
  location                     = azurerm_resource_group.primary.location
  resource_group_name          = azurerm_resource_group.primary.name
  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "pip_secondary" {
  name                         = var.pip_secondary
  location                     = azurerm_resource_group.secondary.location
  resource_group_name          = azurerm_resource_group.secondary.name
  allocation_method = "Dynamic"
}


# application gateway primary
resource "azurerm_application_gateway" "appgw_primary" {
  name                = var.appgw_primary
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
 
  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = azurerm_subnet.websubnet1.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.pip_primary.id
  }

  backend_address_pool {
    name        = azurerm_virtual_network.primarynet.name
    fqdns = ["${azurerm_app_service.app-service-primary.name}.azurewebsites.net"]
  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/"
    host                = "${azurerm_app_service.app-service-primary.name}.azurewebsites.net"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    probe_name = "probe"
  }

  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = azurerm_virtual_network.primarynet.name
    backend_http_settings_name = "http"
  }
}

# application gateway secondary`
resource "azurerm_application_gateway" "appgw_secondary" {
  name                = var.appgw_secondary
  resource_group_name = azurerm_resource_group.secondary.name
  location            = azurerm_resource_group.secondary.location
 
  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "subnet"
    subnet_id = azurerm_subnet.websubnet2.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.pip_secondary.id
  }

  backend_address_pool {
    name        = azurerm_virtual_network.secondarynet.name
    fqdns = ["${azurerm_app_service.app-service-secondary.name}.azurewebsites.net"]
  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/"
    host                = "${azurerm_app_service.app-service-secondary.name}.azurewebsites.net"
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    probe_name = "probe"
  }

  request_routing_rule {
    name                       = "http"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = azurerm_virtual_network.secondarynet.name
    backend_http_settings_name = "http"
  }
}

# traffic manager api
resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = var.traffic_manager
  resource_group_name    = azurerm_resource_group.trafficmanager.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "tm-jck-teamthree"
    ttl           = 300
  }

  monitor_config {
    protocol = "http"
    port     = 80
    path     = "/"
  }
}

# treaffic manager endpoints
resource "azurerm_traffic_manager_endpoint" "tmendpoint_primary" {
  name                = var.tmendpoint_primary
  resource_group_name = azurerm_resource_group.trafficmanager.name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  type                = "externalEndpoints"
  target              = azurerm_public_ip.pip_primary.fqdn
  endpoint_location   = azurerm_public_ip.pip_primary.location
}

resource "azurerm_traffic_manager_endpoint" "tmendpoint_secondary" {
  name                = var.tmendpoint_secondary
  resource_group_name = azurerm_resource_group.trafficmanager.name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  type                = "externalEndpoints"
  target              = azurerm_public_ip.pip_secondary.fqdn
  endpoint_location   = azurerm_public_ip.pip_secondary.location
}