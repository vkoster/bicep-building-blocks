/* =============================================================================
This assembler creates a VM
- with exactly 1 nic
  - to be created here
    - with one optional pip
      - created here
      - or already existing
    - with an optional nsg
      - created here
      - or already existing
  - or already existing

If you choose to create the nic here, then you decide about pip and nsg.
If you choose to reference an already existing nic, you have to take it
as it is. 

----------------------------------------------------------------------------- */
// Location einmal für alle Module ermitteln
param location            string = resourceGroup().location
// VNet
param vnetName            string
param snetName            string
// public IP-Address
param existingPip         bool           // assign existing Pip
param newPip              bool           // asign new Pip
param pipName string
param pipSku object
param pipProperties object
// Network Security Group
param existingNsg         bool           // assign existing NSG
param newNsg              bool           // assign new NSG
param nsgName string
param nsgProperties object
param nsgsrSecurityRules  array           // children: security rules 
param createRules bool                   // flag for creating the rules
// NIC Parameter
param existingNic         bool           // assign existing NSG
param newNic              bool             // assign new NSG
param nicName             string
param nicProperties       object


// VM Parameter
param vmName        string
param vmProperties  object

// find the VNet
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnetName
}
resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing =  {
  name: snetName
  parent: vnet
}

// find existig pip
resource pipExisting 'Microsoft.Network/publicIPAddresses@2022-05-01' existing = if (existingPip && newNic) {
  name: pipName
}
// create a new pip
module pipNew '../../core/pip/pip.bicep' = if (newPip && newNic) {
  name: 'pipCreate'
  params: {
    location:       location
    pipName:        pipName
    pipSku:         pipSku
    pipProperties:  pipProperties
  }
}

// find existing NSG for assignment
resource nsgExisting 'Microsoft.Network/networkSecurityGroups@2022-05-01' existing = if (existingNsg && newNic) {
  name: nsgName
}
// create new nsg
module nsgNew '../../core/nsg/nsg.bicep' = if (newNsg && newNic) {
  name: 'nsgDeploy'
  params: {
    location: location
    nsgName: nsgName
    nsgProperties: nsgProperties
    nsgsrSecurityRules: nsgsrSecurityRules
    createRules: createRules
  }
}

// do the next steps only if we want to create a new nic here!!!
// now comes the injection part!
// get first array element for injection
var ipConfigElement         = (newNic) ? nicProperties.ipConfigurations[0] : {}

// the network gets injected if we want a new nic
var injectedIpConfigElement0 = (newNic) ? union(ipConfigElement, {
  properties: {
    subnet: {
      id: snet.id
    }
  }
}) : ipConfigElement

// inject the existing pip if we want that
var injectedIpConfigElement1 = (existingPip && newNic) ? union(injectedIpConfigElement0, {
  properties: {
    publicIPAddress: {
      id: pipExisting.id
    }
  }
}) : injectedIpConfigElement0

// inject the new pip if we want that
var injectedIpConfigElement2 = (newPip && newNic) ? union(injectedIpConfigElement1, {
  properties: {
    publicIPAddress: {
      id: pipNew.outputs.id
    }
  }
}) : injectedIpConfigElement1

// merge the array back into the properties
var ipconfInjected = (newNic) ? union(nicProperties, {
  ipConfigurations: [injectedIpConfigElement2]
}) : {}

// inject existing NSG or do nothing
var nsgInjected1 = (existingNsg && newNic) ? union(ipconfInjected, {
  networkSecurityGroup: {
      id: nsgExisting.id
    }  
}) : ipconfInjected

// conditionally inject nsg...
var nsgInjected2 = (newNsg && newNic) ? union(nsgInjected1, {
  networkSecurityGroup: {
      id: nsgNew.outputs.id
    }  
}) : nsgInjected1

// 
resource nicExisting 'Microsoft.Network/networkInterfaces@2022-07-01' existing = if (existingNic) {
  name: nicName
}

// create new nic with above injected references 
module nicModule '../../core/nic/nic.bicep' = if (newNic) {
  name: 'nicDeploy'
  params: {
    location: location
    nicName: nicName
    nicProperties: nsgInjected2
  }
}

// inject existing nic into vm properties
// (we inject a complete NIC-array... could be done more suttle)
var nicInjected1 = (existingNic) ? union(vmProperties, {
  networkProfile: {
    networkInterfaces: [
      {
        id: nicExisting.id
      }
    ]
  }
}) : vmProperties

// inject newly created nic into vm properties
var nicInjected2 = (newNic) ? union(nicInjected1, {
  networkProfile: {
    networkInterfaces: [
      {
        id: nicModule.outputs.id
      }
    ]
  }
}) : nicInjected1

// everything is inplace to create the VM
module vmModule '../../core/vm/vm.bicep' = {
  name:'vmDeploy'
  params: {
    location:     location
    vmName:       vmName
    vmProperties: nicInjected2
  }
}
