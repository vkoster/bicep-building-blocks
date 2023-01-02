<# ==============================================================================
Verwende das Template und erstelle alle VNets aus dem Instance-Verzeichnis des
Landes in der übergebenen Umgebung
#>
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
Write-Host("path: ./deploy/assembler/nsg/$country/$stage")

# Get-ChildItem -Path ./instances -Name
$instances = Get-ChildItem -Path ./deploy/assembler/nsg/$country/$domain/$stage/*.json -Name
Write-Host("nsg instances to deploy: "+$instances)
foreach ($instance in $instances) {
    Write-Host("creating nsg instance "+$instance)
    az deployment group create --resource-group $resourceGroup --template-file ./deploy/assembler/nsg/main.bicep --parameters ./deploy/assembler/nsg/$country/$domain/$stage/$instance
}
