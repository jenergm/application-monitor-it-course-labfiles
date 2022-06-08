Connect-AzAccount
Get-AzSubscription
Select-AzSubscription -SubscriptionId "31302e91-c2ba-4c79-8860-47ec27e7d124"
$workspaceName = "workshopjenergm20220607"
$resourcegroup = "azureworkshop"
$workspace = Get-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $resourcegroup

if ($workspace.Name -ne $workspaceName)
{
    Write-Error "Unable to find OMS Workspace $workspaceName."
}

$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKey -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey
#get all vms within the resource group
$vms = Get-AzVM -ResourceGroupName $resourcegroup -Name workshopvmjgm2

foreach ($vm in $vms)
{
    $location = $vm.Location
    $vm = $vm.Name  
    # For Windows VM uncomment the following line
    Set-AzVMExtension -ResourceGroupName $resourcegroup -VMName $vm -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId': '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
}