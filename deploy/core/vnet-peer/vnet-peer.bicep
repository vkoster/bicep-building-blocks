/*
This script needs to be called with 2 sets of parametes:
- VNet 1
  - Link in VNet 1
- Vnet 2
  - Link in VNet 2

VNet peers sind Child Resourcen von Vnets. Darum sind Peers echte Core Module. Das Referenzieren der existierenden
VNets im Core Modul ist daher legitim.
*/

param vnet1Name string
param vnet2Name string
param peer1Name string
param peer2Name string
// peer1 Properties
param peer1Properties object
// pier2 Properties
param peer2Properties object

// Beide VNets müssen bereits existieren.
// Diese VNets werden über ihren Namen gefunden
// Achtung: diese Abfragen müssen hier passieren, da der Symbolic Name unten als Parent
//          verwendet wird.
resource vnet1 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnet1Name
}

resource vnet2 'Microsoft.Network/virtualNetworks@2022-05-01' existing =  {
  name: vnet2Name
}
      
// leg in VNet1
// vnet2Id has to be injected
var injectedProperties1 = union(peer1Properties, {
  remoteVirtualNetwork: { 
    id: vnet2.id
  }
})

// vnet2Id has to be injected
var injectedProperties2 = union(peer2Properties, {
  remoteVirtualNetwork: {
    id: vnet1.id
  }
})

resource vnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  parent: vnet1
  name: peer1Name
  properties: injectedProperties1
}

// leg in VNet2
resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  parent: vnet2
  name: peer2Name
  properties: injectedProperties2
}

