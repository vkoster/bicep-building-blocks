param location string = resourceGroup().location
param vnetName string
param vnetProperties object
param snetSubnets array 

// consuming the VNet Core Module
module vnetModule '../../core/vnet/vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    location:                 location
    vnetName:                 vnetName
    vnetProperties:           vnetProperties
    snetSubnets:              snetSubnets
  }
}
