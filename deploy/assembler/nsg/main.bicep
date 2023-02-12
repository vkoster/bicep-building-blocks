param nsgName string
param nsgProperties object
param nsgsrSecurityRules array       // children: security rules 
param createRules bool               // flag for creating the rules

param location string = resourceGroup().location

// consuming the NSG Core Module
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
