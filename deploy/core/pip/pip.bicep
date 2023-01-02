param location string
param pipName string
param pipSku object
param pipProperties object

// public IP-Address
resource pip 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  location:   location
  name:       pipName
  sku:        pipSku
  properties: pipProperties
}

// name and resource id are important
output name string = pip.name
output id string   = pip.id
