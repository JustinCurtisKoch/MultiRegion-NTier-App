#resource group variables
resource_group_name_primary   = "primaryRG"
location_primary              = "eastus"
resource_group_name_secondary = "secondaryRG"
location_secondary            = "centralus"
resource_group_name_tm        = "trafficmanagerRG"
location_tm                   = "eastus"

#virtual networks variables
network_name_primary = "vnetprimary"
#add address space
network_name_secondary = "vnetsecondary"
#add address space
network_name_tm = "vnettrafficmanager"
#add address space

#primary vnet subnets
managementsubnet1 = "managementsubnet1"
#add variable subnet space
websubnet1 = "websubnet1"
#add variable subnet space
businesssubnet1 = "businesssubnet1"
#add variable subnet space
datasubnet1 = "databasesubnet1"
#add variable subnet space
ADsubnet1 = "activedirectorysubent1"
#add variable subnet space

#secondary vnet subnets
managementsubnet2 = "managementsubnet2"
#add variable subnet space
websubnet2 = "websubnet2"
#add variable subnet space
businesssubnet2 = "businesssubnet2"
#add variable subnet space
datasubnet2 = "databasesubnet2"
#add variable subnet space
ADsubnet2 = "activedirectorysubent2"
#add variable subnet space

#traffic manager vnet subnet
trafficmanagersubnet = "trafficmanagersubnet"
#add variable subnet space

#virtual network peering
primarytosecondary = "primarytpsecondary"
secondarytoprimary = "secondarytoprimary"

#app service plans
appserviceplan_primary = "appserviceplan_primary"
appserviceplan_secondary = "appserviceplansecondary"

# app services
appservice_primary = "appservice-primary"
appservice_secondary = "appservice-secondary"

# dynamic ip addresses
pip_primary = "pip_primary"
pip_secondary = "pip_secondary"

# application gateway
appgw_primary = "appgw_primary"
appgw_secondary = "appgw_secondary"

# traffic manager
traffic_manager = "trafficmanagerteamthree"
tmendpoint_primary = "tmendpoint_primary"
tmendpoint_secondary = "tmendpoint_secondary"

#data tier load balancer
vnet1datalb = "vnet1datalb"
vnet2datalb = "vnet2datalb"

#data tier nic
vnet1sqlnic = "vnet1sqlnic"
vnet2sqlnic = "vnet2sqlnic"

#data tier sql server
vnet1sqlserver = "vnet1sqlserver"
vnet2sqlserver = "vnet2sqlserver"

#BASTION HOSTS
bastion1_pip  = "bastion1pip"
bastion2_pip  = "bastion2pip"
bastion1_name = "bastionprimary"
bastion2_name = "bastionsecondary"

#LOAD BALLENCERS- business tier
vnet1buslb = "vnetbusl1b"
vnet2buslb = "vnetbus2lb"