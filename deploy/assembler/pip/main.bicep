// public IP-Address
param pipName string
param pipSku object
param pipProperties object

param location string = resourceGroup().location

// consuming the PIP Core Module
module pipModule '../../core/pip/pip.bicep' = {
  name: 'pipDeploy'
  params: {
    location: location
    pipName: pipName
    pipSku:  pipSku
    pipProperties: pipProperties
  }
}
