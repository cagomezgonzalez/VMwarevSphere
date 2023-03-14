Connect-VIServer -Server <vCenterFQDNorIP> -User <vcenterUser> -Password <password>
$dvSwitchName = "<DistributedSwitchName>"
$dvPortGroupName = "<DistributedPortName>"
$dvSwitch = Get-VDSwitch -Name $dvSwitchName
$dvPortGroup = Get-VDPortGroup -Name $dvPortGroupName -VDSwitch $dvSwitch

$originalSecurityPolicy=$dvPortGroup.ExtensionData.Config.DefaultPortConfig.SecurityPolicy

$spec = New-Object VMware.Vim.DVPortgroupConfigSpec
$dvPortSetting = New-Object VMware.Vim.VMwareDVSPortSetting
$macMmgtSetting = New-Object VMware.Vim.DVSMacManagementPolicy
$macLearnSetting = New-Object VMware.Vim.DVSMacLearningPolicy
$macMmgtSetting.MacLearningPolicy = $macLearnSetting
$dvPortSetting.MacManagementPolicy = $macMmgtSetting
$spec.DefaultPortConfig =$dvPortSetting
$spec.ConfigVersion =$dvPortGroup.ExtensionData.Config.ConfigVersion

$macMmgtSetting.AllowPromiscuous = $false
$macMmgtSetting.ForgedTransmits = $true
$macMmgtSetting.MacChanges = $false
$macLearnSetting.Enabled = $true
$macLearnSetting.AllowUnicastFlooding =$true
$macLearnSetting.LimitPolicy = "DROP"
$macLearnsetting.Limit = 4096

Write-Host "Enabling MAC Learning on DVPortgroup: $dvPortGroupName..."
$task=$dvPortGroup.ExtensionData.ReconfigureDVPortgroup_Task($spec)
$task1=Get-Task-Id("Task-$($task.value)")
$task1 | Wait-Task | Out-Null 
