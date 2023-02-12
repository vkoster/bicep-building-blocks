param location string
param vnetName string
param vnetProperties object
param snetSubnets array 

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name:       vnetName
  location:   location
  properties: vnetProperties
}

// Subnet als Child Resource, extern definiert
// (da ein Subnet obligatorisch ist, ist das kein bedingtes Deployment)
@batchSize(1)
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for snetSubnet in snetSubnets: {
  name:       snetSubnet.snetName
  parent:     vnet
  properties: snetSubnet.snetProperties
}]

