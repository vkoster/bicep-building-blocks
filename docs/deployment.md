---
permalink: /deployment/
title: deployment
description: This page describes how to deploy the Bicep modules for testing and verification
---
# Deployment
## Introduction
Deploying Azure resources is not what this repository is about.
Its just a way to demonstrate that things are working and see the building blocks in action.
As mentioned already, I came into contact with Bicep in a largish project consisting of number of business domains
who's resources had to be rolled out to different countries.
Of course I wanted be able to do the same, even when my focus was on reusing Bicep code.
This is really the only reason for the structures chosen here and I will keep this section as short as possible.

## Deployment Options
Deployment can be done in two ways:
- running an Azure DevOps Pipeline 
  - the pipeline is defined in azure-pipelines.yml
- running scripts from a local PowerShell console

Both the pipeline and the local PowerShell are running the same assembler scripts, which are parameterized in 
exactly the same way (see below).

## The Setup
So I want to deploy Azure resources for my domains into different countries.
Naturally, I also want to support different environments like e.g. development, qa and production.

This leads to the following parameters:
````
$country       = "de"                                // the country to roll out to (Germany in this case)
$domain        = "az700"                             // the domain (derived from an Azure course I was taking :-)) 
$stage         = "dev"                               // an example for a deployment stage (development)
$resourceGroup = "rg-${country}-${domain}-${stage}"
````
These parameters define both what is to be deployed and the Azure resource group to deploy into.

Without going into details about assembler and core module, described here (TODO: insert link), 
let's take a look at the deployment of public IPs:

<img src="{{site.baseurl}}/images/Deploy-PIPs.png">

This shows the layout of directories:
- assembler/ is the top-level directory, hosting all assembler modules"
- pip/ contains the public IP assembler
- de/ is the directory representing Germany (right now, there are no other countries)
- az700/ and "playground" are domain directories (az700 and playoground are my example-domains)
- dev/ beneath "az700" represents the development environment

Talking about the files in these directories:
- pip/ (the root of the pip assembler)
  - "deploy.ps1" is the PowerShell script which deploys the PIP by calling the assembler (see below)
    - called with the parameters described above 
  - "main.bicep" contains the PIP assembler code which calls the PIP core module
- pip/de/az700/dev/
  - "instance01.json" is a parameter file containing everything needed to create one pip instance

Finally, let's take a look at the actual deployment code:
````
[CmdletBinding()]
Param (
    [parameter(Mandatory)]
    [String]$country,
    [parameter(Mandatory)]
    [String]$domain,
    [parameter(Mandatory)]
    [String]$stage,
    [parameter(Mandatory)]
    [String]$resourceGroup

)

# Get-ChildItem -Path ./instances -Name
$instances = Get-ChildItem -Path ./deploy/assembler/pip/$country/$domain/$stage/*.json -Name
Write-Host("pip instances to deploy: "+$instances)
foreach ($instance in $instances) {
    Write-Host("creating pip instance "+$instance)
    az deployment group create --resource-group $resourceGroup --template-file ./deploy/assembler/pip/main.bicep --parameters ./deploy/assembler/pip/$country/$domain/$stage/$instance
}
````
The parameters define the "deployment vector": (country, domain, stage).
The loop picks up every pip instance.json file within the directory denoted by the deployment vector
(currently, there is ony one) and deploys it by calling on the Azure CLI.

This structure is the same for all building blocks.

## Deploy locally or via Azure Pipeline
### Run a local deployment
To do a local deployment:
- open PowerShell and log into your Azure account
- define the parameters for the deployment vector
- run the deploy.ps1 script

````
$country = "de"
$domain  = "az700"
$stage   = "dev"
$resourceGroup = "rg-${country}-${domain}-${stage}"
./deploy/assembler/pip/deploy.ps1 -country $country -domain $domain -stage $stage -resourceGroup $resourceGroup
````
Note: for this to work, the resource group must already exist (there is a special module for creating resouce groups).

The file "local-tests.ps1" contains a call for each currently available assembler:
```
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
```
Copy an assembler call and paste it into PowerShell console running an Azure connection.

### Deploy via Azure Pipeline
The pipeline does exactly the same.
Here is the snippet containing the pip task:
````
- task: AzureCLI@2
  displayName: 'Assembler: creating public IPs'
  condition: false
  inputs:
    azureSubscription: 'aks-devops-terraform-auto-all'
    scriptType: 'pscore'
    scriptLocation: 'scriptPath'
    arguments: '-country ${{parameters.country}} -domain ${{parameters.domain}} -stage ${{parameters.stage}} -resourceGroup rg-${{parameters.country}}-${{parameters.domain}}-${{parameters.stage}}'
    scriptPath: $(Build.SourcesDirectory)/deploy/assembler/pip/deploy.ps1
````

|[home](index.md) | [design decisions](design-decisions.md)| [deployment](deployment.md)|