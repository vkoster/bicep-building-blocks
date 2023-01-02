/*
This script needs to be called with 2 sets of parametes:
- VNet 1
  - Link in VNet 1
- Vnet 2
  - Link in VNet 2
*/
param vnet1Name string
param vnet2Name string
param peer1Name string
param peer2Name string
// peer1 Properties
param peer1Properties object
// pier2 Properties
param peer2Properties object

// 
module vnetpeerModule '../../core/vnet-peer/vnet-peer.bicep' = {
  name: 'vnetpeerDeploy'
  params: {
    vnet1Name: vnet1Name
    vnet2Name: vnet2Name
    peer1Name: peer1Name
    peer2Name: peer2Name
    // peer1 Properties
    peer1Properties: peer1Properties
    // pier2 Properties
    peer2Properties: peer2Properties
  }
}
