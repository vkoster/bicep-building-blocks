param location string
param nsgName string
param nsgProperties object
param nsgsrSecurityRules array
param createRules bool

// Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: nsgName
  location: location
  properties: nsgProperties
}

// Deploy Rules-Array
//   Achtung: Loop mit Condition
@batchSize(1)
resource nsgrRules 'Microsoft.Network/networkSecurityGroups/securityRules@2022-05-01' = [for  nsgsrSecurityRule in  nsgsrSecurityRules: if(createRules) {
  parent: nsg
  name:        nsgsrSecurityRule.name
  properties:  nsgsrSecurityRule.properties
}]

// name and resource id are important
output name string = nsg.name
output id string = nsg.id
