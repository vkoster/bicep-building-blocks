param location            string = resourceGroup().location
// VNet
param vnetName            string
param snetName            string
// Pip
param existingPip         bool           // assign existing Pip
param newPip              bool           // asign new Pip
param pipName             string
param pipSku              object
param pipProperties       object
// Nsg
param existingNsg         bool           // assign existing NSG
param newNsg              bool           // assign new NSG
param nsgName             string
param nsgProperties       object
param nsgsrSecurityRules  array
param createRules         bool
// Nic
param nicName             string
param nicProperties       object

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnetName
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing =  {
  name: snetName
  parent: vnet
}

// 
resource pipExisting 'Microsoft.Network/publicIPAddresses@2022-05-01' existing = if (existingPip) {
  name: pipName
}

module pipNew '../../core/pip/pip.bicep' = if (newPip) {
  name: 'pipCreate'
  params: {
    location: location
    pipName: pipName
    pipSku:  pipSku
    pipProperties: pipProperties
  }
}

// find existing NSG for assignment
resource nsgExisting 'Microsoft.Network/networkSecurityGroups@2022-05-01' existing = if (existingNsg) {
  name: nsgName
}

// create NSG by consuming the NSG Core Module
module nsgNew '../../core/nsg/nsg.bicep' = if (newNsg) {
  name: 'nsgCreate'
  params: {
    location: location
    nsgName: nsgName
    nsgProperties: nsgProperties
    nsgsrSecurityRules: nsgsrSecurityRules
    createRules: createRules
  }
}

// injecting into array elements is a special case
// get first array element for injection
var ipConfigElement         = nicProperties.ipConfigurations[0]
var injectedIpConfigElement0 = union(ipConfigElement, {
  properties: {
    subnet: {
      id: snet.id
    }
  }
})

// inject the existing pip if we want that
var injectedIpConfigElement1 = (existingPip) ? union(injectedIpConfigElement0, {
  properties: {
    publicIPAddress: {
      id: pipExisting.id
    }
    subnet: {
      id: snet.id
    }
  }
}) : injectedIpConfigElement0

// inject the new pip if we want that
var injectedIpConfigElement2 = (newPip) ? union(injectedIpConfigElement1, {
  properties: {
    publicIPAddress: {
      id: pipNew.outputs.id
    }
    subnet: {
      id: snet.id
    }
  }
}) : injectedIpConfigElement1

// merge the array back into the properties
var pipInjected = union(nicProperties, {
  ipConfigurations: [injectedIpConfigElement2]
})

// inject existing NSG or do nothing
var nsgInjected1 = (existingNsg) ? union(pipInjected, {
  networkSecurityGroup: {
      id: nsgExisting.id
    }  
}) : pipInjected

// conditionally inject newly created NSG
var nsgInjected2 = (newNsg) ? union(nsgInjected1, {
  networkSecurityGroup: {
      id: nsgNew.outputs.id
    }  
}) : nsgInjected1

// Finally consuming the NIC Core Module
module nicModule '../../core/nic/nic.bicep' = {
  name: 'nicDeploy'
  params: {
    location: location
    nicName: nicName
    nicProperties: nsgInjected2
  }
}

// outputs for debugging
output ipConfigElement          object = ipConfigElement
output injectedIpConfigElement0 object = injectedIpConfigElement0
output injectedIpConfigElement1 object = injectedIpConfigElement1
output injectedIpConfigElement2 object = injectedIpConfigElement2
output pipInjected              object = pipInjected
output nsgInjected1             object = nsgInjected1
output nsgInjected2             object = nsgInjected2
