param location string = resourceGroup().location
param nicName string
param nicProperties object

// Network Interface Card
resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name:       nicName
  location:   location
  properties: nicProperties
}

// name and resource id are important
output name string  = nic.name
output id string    = nic.id
