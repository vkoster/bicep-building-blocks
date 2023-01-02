<# =============================================================================
Verwende das Template und erstelle alle VNet Peerings aus dem Instance-
Verzeichnis des Landes für die übergebenen Umgebung.
----------------------------------------------------------------------------- #>
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
# Check the parametes
Write-Host("Check Parameters:")
Write-Host("country: "+$country)
Write-Host("domain: "+$domain)
Write-Host("stage: "+$stage)
Write-Host("resourceGroup: "+$resourceGroup)
Write-Host("path: ./deploy/assembler/vnet-peer/$country/$domain/$stage/")

# Get-ChildItem -Path ./instances -Name
$instances = Get-ChildItem -Path ./deploy/assembler/vnet-peer/$country/$domain/$stage/*.json -Name
Write-Host("vnet-peer instances to deploy: "+$instances)
foreach ($instance in $instances) {
    Write-Host("creating vnet-peer instances "+$instance)
    az deployment group create --resource-group $resourceGroup --template-file ./deploy/assembler/vnet-peer/main.bicep --parameters ./deploy/assembler/vnet-peer/$country/$domain/$stage/$instance
}
