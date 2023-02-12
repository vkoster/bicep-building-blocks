// storage account
@description('Storage Account Sku')
param stSku object
@description('The name of the Storage Account')
param stName string
param stKind string

// BlobServices
param stbsProperties object

//Containers
param stbsconName string

// Decide on child-modules to be created
param createBlobServices bool
param createContainers   bool

param  location string = resourceGroup().location

// consuming the storage-account Core Module
module stModule '../../core/storage-account/storage-account.bicep' = {
  name: 'stDeploy'
  params: {
    stLocation: location
    stSku: stSku
    stName: stName
    stKind: stKind
    stbsProperties: stbsProperties
    sabsconName: stbsconName
    createBlobServices: createBlobServices
    createContainers: createContainers
  }
}

