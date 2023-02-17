<# =============================================================================
How to run the tests:
- open a Powershell console and switch to root-directory of this repo
- log into your Azure Account (and define a default-subscription if approriate)
- define values for $country, $domain, $stage and $resourceGroup (see examples below)
- run the deploy-script that you want to test

Remarks:
- $country, $domain and $stage are just parameters that define the resouce group to deploy to
- the resource group must already be in place - it will not be created automatically

============================================================================= #>


# Call an assebmler from a PowerShell console
$country = "de"
$domain  = "az700"
$stage   = "dev"
$resourceGroup = "rg-${country}-${domain}-${stage}"
$country = "de"
$domain  = "playground"
$stage   = "dev"
$resourceGroup = "rg-${country}-${domain}-${stage}"
./deploy/assembler/vnet/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/vnet-peer/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/storage-account/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/nsg/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/pip/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/nic/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
./deploy/assembler/vm/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup


# Alt: Test auf dem einstufigen Modules Konzept
./modules/resourcegroup/deploy.ps1 -country de -stage dev -metaLocation westeurope
./modules/vnet/deploy.ps1 -country de -stage dev -resourceGroup rg-de-dev-az700
./modules/vnet-peer/deploy.ps1 -country de -stage dev -resourceGroup rg-de-dev-playground
