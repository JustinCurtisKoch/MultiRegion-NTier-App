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

#primary virtual network- data tier load balancer
resource "azurerm_lb" "vnet1datalb" {
  name                = var.vnet1datalb
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.datasubnet1.id
    private_ip_address            = "10.0.4.5"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_backend_address_pool" "vnet1databepool" {
  resource_group_name = azurerm_resource_group.primary.name
  loadbalancer_id     = azurerm_lb.vnet1datalb.id
  name                = "BackEndAddressPool"
}

#primary virtual network- data tier nic
resource "azurerm_network_interface" "vnet1sqlnic" {
  name                = var.vnet1sqlnic
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datasubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "vnet1sqlnicbepool" {
  network_interface_id    = azurerm_network_interface.vnet1sqlnic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vnet1databepool.id
}

#primary virtual network- data tier sql server
resource "azurerm_virtual_machine" "vnet1sqlserver" {
  name                  = var.vnet1sqlserver
  location              = azurerm_resource_group.primary.location
  resource_group_name   = azurerm_resource_group.primary.name
  network_interface_ids = [azurerm_network_interface.vnet1sqlnic.id]
  vm_size               = "Standard_DS1_v2"

  #Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2016SP2-WS2016"
    sku       = "SQLDEV"
    version   = "latest"
  }

  storage_os_disk {
    name              = "sqloneosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "P@55word2022"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}

#secondary virtual network- data tier load balancer
resource "azurerm_lb" "vnet2datalb" {
  name                = var.vnet2datalb
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.datasubnet2.id
    private_ip_address            = "10.1.4.5"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_backend_address_pool" "vnet2databepool" {
  resource_group_name = azurerm_resource_group.secondary.name
  loadbalancer_id     = azurerm_lb.vnet2datalb.id
  name                = "BackEndAddressPool"
}

#secondary virtual network- data tier nic
resource "azurerm_network_interface" "vnet2sqlnic" {
  name                = var.vnet2sqlnic
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datasubnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "vnet2sqlnicbepool" {
  network_interface_id    = azurerm_network_interface.vnet2sqlnic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vnet2databepool.id
}

#secondary virtual network- data tier sql server
resource "azurerm_virtual_machine" "vnet2sqlserver" {
  name                  = var.vnet2sqlserver
  location              = azurerm_resource_group.secondary.location
  resource_group_name   = azurerm_resource_group.secondary.name
  network_interface_ids = [azurerm_network_interface.vnet2sqlnic.id]
  vm_size               = "Standard_DS1_v2"

  #Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2016SP2-WS2016"
    sku       = "SQLDEV"
    version   = "latest"
  }

  storage_os_disk {
    name              = "sqltwoosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "P@55word2022"
  }
  os_profile_windows_config {
    provision_vm_agent = true
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
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
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

resource "azurerm_lb_rule" "lb1natrule" {
   resource_group_name            = azurerm_resource_group.primary.name
   loadbalancer_id                = azurerm_lb.vnet1buslb.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = 50000
   backend_port                   = 50010
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bus1bepool.id
   frontend_ip_configuration_name = "PrivateIPAddress"
   probe_id                       = azurerm_lb_probe.businesshealth1.id
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

resource "azurerm_lb_rule" "lb2natrule" {
   resource_group_name            = azurerm_resource_group.secondary.name
   loadbalancer_id                = azurerm_lb.vnet2buslb.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = 50000
   backend_port                   = 50010
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bus2bepool.id
   frontend_ip_configuration_name = "PrivateIPAddress"
   probe_id                       = azurerm_lb_probe.businesshealth2.id
}

#BUSINESS TIER VM1 Scale Set
#Health probe for the VMS in Business 1
resource "azurerm_lb_probe" "businesshealth1" {
  resource_group_name = azurerm_resource_group.primary.location
  loadbalancer_id     = azurerm_lb.vnet1buslb.id
  name                = "http-probe-business1"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}

#Scale Set- Business Teir
resource "azurerm_virtual_machine_scale_set" "businesstier1" {
  name                = "businesstier1"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.businesshealth1.id

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
#Health probe for the VMS in Business 2
resource "azurerm_lb_probe" "businesshealth2" {
  resource_group_name = azurerm_resource_group.secondary.location
  loadbalancer_id     = azurerm_lb.vnet2buslb.id
  name                = "http-probe-business2"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}


#Scale Set- Business Teir 2
resource "azurerm_virtual_machine_scale_set" "businesstier2" {
  name                = "businesstier2"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy (Buisness 2)
  health_probe_id = azurerm_lb_probe.businesshealth2.id

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