// für alle Ressourcen
param location string = resourceGroup().location
param vmName string
param vmProperties object



resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: vmProperties
}  

// name and resource id are important
output name string = vm.name
output id string   = vm.id
