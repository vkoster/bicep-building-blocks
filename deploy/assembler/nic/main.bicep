param location      string = resourceGroup().location
param nicName       string
param vnetName      string
param snetName      string
param pipName       string
param nsgName       string
param nicProperties object
param createNsg     bool

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnetName
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing =  {
  name: snetName
  parent: vnet
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-05-01' existing =  {
  name: pipName
}

// get the nsg only, if it should be created
resource nsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' existing = if (createNsg) {
  name: nsgName
}

// get first array element for injection
var ipConfigElement         = nicProperties.ipConfigurations[0]
var injectedIpConfigElement = union(ipConfigElement, {
  properties: {
    publicIPAddress: {
      id: pip.id
    }
    subnet: {
      id: snet.id
    }
  }
})

// merge the array back into the properties
var merge = union(nicProperties, {
  ipConfigurations: [injectedIpConfigElement]
})

// conditionally inject nsg...
var merge2 = (createNsg) ? union(merge, {
  networkSecurityGroup: {
      id: nsg.id
    }  
}) : merge

// consuming the NIC Core Module
module nicModule '../../core/nic/nic.bicep' = {
  name: 'nicDeploy'
  params: {
    location: location
    nicName: nicName
    nicProperties: merge2
  }
}

output merge object = merge
output merge2 object = merge2
output injectedIpConfigElement object = injectedIpConfigElement
