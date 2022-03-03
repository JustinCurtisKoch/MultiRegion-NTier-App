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

#primary vnet subnet
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

#primary vnet subnet- Bastion
resource "azurerm_subnet" "AzureBastionSubnet1" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.primarynet.name
  address_prefixes     = ["10.0.6.0/24"]
}

#secondary vnet subnet
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

#Secondary vnet subnet- Bastion
resource "azurerm_subnet" "AzureBastionSubnet2" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondarynet.name
  address_prefixes     = ["10.1.6.0/24"]
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
  name                = var.pip_primary
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "pip_secondary" {
  name                = var.pip_secondary
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  allocation_method   = "Dynamic"
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
    name  = azurerm_virtual_network.primarynet.name
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
    probe_name            = "probe"
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
    name  = azurerm_virtual_network.secondarynet.name
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
    probe_name            = "probe"
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
    relative_name = "tm-jck-teamthreetest"
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
  target              = "${azurerm_public_ip.pip_primary.fqdn}"
  endpoint_location   = "${azurerm_public_ip.pip_primary.location}"
}

resource "azurerm_traffic_manager_endpoint" "tmendpoint_secondary" {
  name                = var.tmendpoint_secondary
  resource_group_name = azurerm_resource_group.trafficmanager.name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  type                = "externalEndpoints"
  target              = "${azurerm_public_ip.pip_secondary.fqdn}"
  endpoint_location   = "${azurerm_public_ip.pip_secondary.location}"
}

#SQL server fail over group
resource "azurerm_mssql_server" "primarysqlserver" {
  name                         = "mssqlserver-primary"
  resource_group_name          = azurerm_resource_group.primary.name
  location                     = azurerm_resource_group.primary.location
  version                      = "12.0"
  administrator_login          = "azureuser"
  administrator_login_password = "P@55word2022"
}

resource "azurerm_mssql_server" "secondarysqlserver" {
  name                         = "mssqlserver-secondary"
  resource_group_name          = azurerm_resource_group.secondary.name
  location                     = azurerm_resource_group.secondary.location
  version                      = "12.0"
  administrator_login          = "azureuser"
  administrator_login_password = "P@55word2022"
}

resource "azurerm_mssql_database" "sqldatabase" {
  name        = "sqldatabase"
  server_id   = azurerm_mssql_server.primarysqlserver.id
  sku_name    = "S1"
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = "200"
}

resource "azurerm_mssql_failover_group" "sqlfailover" {
  name      = "sqlfailoverthree"
  server_id = azurerm_mssql_server.primarysqlserver.id
  databases = [
    azurerm_mssql_database.sqldatabase.id
  ]

  partner_server {
    id = azurerm_mssql_server.secondarysqlserver.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 80
  }
}

#BASTION HOSTS
#Bastion 1- VNET 1
#Creating the Public IP: Bastion Host 1
resource "azurerm_public_ip" "bastion1_pip" {
  name                = var.bastion1_pip
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creating the resource: Bastion Host 1
resource "azurerm_bastion_host" "firstBastion" {
  name                = var.bastion1_name
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ip_configuration {
    name                 = "configbastion1"
    subnet_id            = azurerm_subnet.AzureBastionSubnet1.id
    public_ip_address_id = azurerm_public_ip.bastion1_pip.id
  }
}

#Bastion 2- VNET 2
#Creating the Public IP: Bastion Host 2
resource "azurerm_public_ip" "bastion2_pip" {
  name                = var.bastion2_pip
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creating the resource: Bastion Host 2
resource "azurerm_bastion_host" "secondBastion" {
  name                = var.bastion2_name
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name

  ip_configuration {
    name                 = "configbastion2"
    subnet_id            = azurerm_subnet.AzureBastionSubnet2.id
    public_ip_address_id = azurerm_public_ip.bastion2_pip.id
  }
}

#LOAD BALLENCERS
#LB Created for Business Hosts 1
resource "azurerm_lb" "vnet1buslb" {
  name                = var.vnet1buslb
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.businesssubnet1.id
    private_ip_address            = "10.0.3.5"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_backend_address_pool" "bus1bepool" {
  loadbalancer_id = azurerm_lb.vnet1buslb.id
  name            = "BackEndAddressPool1"
}

#LB Created for Business Hosts 2
resource "azurerm_lb" "vnet2buslb" {
  name                = var.vnet2buslb
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name


  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.businesssubnet2.id
    private_ip_address            = "10.1.3.5"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_backend_address_pool" "bus2bepool" {
  loadbalancer_id = azurerm_lb.vnet2buslb.id
  name            = "BackEndAddressPool2"
}

#BUSINESS TIER VM1 Scale Set
#Scale Set- Business Teir
resource "azurerm_virtual_machine_scale_set" "businesstier1" {
  name                = "businesstier1"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  # automatic rolling upgrade
  automatic_os_upgrade = false
  upgrade_policy_mode  = "Manual"

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 3
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "business1"
    admin_username       = "myadmin"
    admin_password       = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false


  }
  #Define Network Profile
  network_profile {
    name    = "business1networkpro"
    primary = true

    ip_configuration {
      name                                   = "BusinessIPConfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.businesssubnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bus1bepool.id]
    }
  }


}

#BUSINESS TIER VM2 Scale Set 2
#Scale Set- Business Teir 2
resource "azurerm_virtual_machine_scale_set" "businesstier2" {
  name                = "businesstier2"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  # automatic rolling upgrade
  automatic_os_upgrade = false
  upgrade_policy_mode  = "Manual"

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 3
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "business2"
    admin_username       = "myadmin"
    admin_password       = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false


  }
  #Define Network Profile (Business 2)
  network_profile {
    name    = "business2networkpro"
    primary = true

    ip_configuration {
      name                                   = "BusinessIPConfig2"
      primary                                = true
      subnet_id                              = azurerm_subnet.businesssubnet2.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bus2bepool.id]
    }
  }
}