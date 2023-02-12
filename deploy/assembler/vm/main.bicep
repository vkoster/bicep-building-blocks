/* =============================================================================
Dieser Assembler legt eine VM mit
- genau einer NIC
  - mit genau einer IP Configuraton
- einer NSG

----------------------------------------------------------------------------- */

// public IP-Address
param pipName string
param pipSku object
param pipProperties object

// Network Security Group
param nsgName string
param nsgProperties object
param nsgsrSecurityRules array       // children: security rules 
param createRules bool               // flag for creating the rules

// NIC Parameter
param nicName       string
param vnetName      string
param snetName      string
param nicProperties object
param createNsg     bool

// VM Parameter
param vmName        string
param vmProperties  object

// Location einmal für alle Module ermitteln
param location      string = resourceGroup().location

// create a pip
module pipModule '../../core/pip/pip.bicep' = {
  name: 'pipDeploy'
  params: {
    location:       location
    pipName:        pipName
    pipSku:         pipSku
    pipProperties:  pipProperties
  }
}

// create an nsg
module nsgModule '../../core/nsg/nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    location: location
    nsgName: nsgName
    nsgProperties: nsgProperties
    nsgsrSecurityRules: nsgsrSecurityRules
    createRules: createRules
  }
}

// create the NIC
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnetName
}

resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing =  {
  name: snetName
  parent: vnet
}

// get first array element for injection
var ipConfigElement         = nicProperties.ipConfigurations[0]
var injectedIpConfigElement = union(ipConfigElement, {
  properties: {
    publicIPAddress: {
      id: pipModule.outputs.id
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
      id: nsgModule.outputs.id
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

// inject the NIC-ID into the VM-Properties:
// (we inject a complete NIC-array... could be done more suttle)
var mergedNic = union(vmProperties, {
  networkProfile: {
    networkInterfaces: [
      {
        id: nicModule.outputs.id
      }
    ]
  }
})

// everything is inplace to create the VM
module vmModule '../../core/vm/vm.bicep' = {
  name:'vmDeploy'
  params: {
    location:     location
    vmName:       vmName
    vmProperties: mergedNic
  }
}
