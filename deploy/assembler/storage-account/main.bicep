// storage account
@description('Storage Account Sku')
param stSku object
@description('Location for the storage account.')
param stLocation string = resourceGroup().location
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

// consuming the storage-account Core Module
module stModule '../../core/storage-account/storage-account.bicep' = {
  name: 'stDeploy'
  params: {
    stLocation: stLocation
    stSku: stSku
    stName: stName
    stKind: stKind
    stbsProperties: stbsProperties
    sabsconName: stbsconName
    createBlobServices: createBlobServices
    createContainers: createContainers
  }
}

