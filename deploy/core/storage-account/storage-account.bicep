// Storage Account
@description('Storage Account sku')
param stSku object
@description('Location for the storage account')
param stLocation string
@description('The name of the Storage Account')
param stName string
param stKind string

// Container Services
@description('storage account blob services properties')
param stbsProperties object

// Container
@description('The name of the Container')
param sabsconName string = 'store${uniqueString(resourceGroup().id)}'

// Decide on child-modules to be created
param createBlobServices bool
param createContainers   bool

// This is the top level staorage account
resource st 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: stName
  location: stLocation
  sku: stSku
  kind: stKind
  properties: {}
}

// Nested blob service (name must be 'default')
resource stbs 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = if (createBlobServices){
  parent: st
  name: 'default'
  properties: stbsProperties
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = if (createContainers) {
  parent: stbs
  name: sabsconName
}

// exporting:
output storageAccountName string = st.name
output storageAccountId string = st.id
