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
Write-Host("path: ./deploy/assembler/vnet/$country/$stage")

# Get-ChildItem -Path ./instances -Name
$instances = Get-ChildItem -Path ./deploy/assembler/vnet/$country/$domain/$stage/*.json -Name
Write-Host("vnet instances to deploy: "+$instances)
foreach ($instance in $instances) {
    Write-Host("creating vnet instance "+$instance)
    az deployment group create --resource-group $resourceGroup --template-file ./deploy/assembler/vnet/main.bicep --parameters ./deploy/assembler/vnet/$country/$domain/$stage/$instance
}
