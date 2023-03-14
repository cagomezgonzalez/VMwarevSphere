Connect-VIServer -Server <vCenterFQDN/IP> -User <vCenterUserName> -Password <password>
$dvSwitchName = "<DistributedSwitchName>"
$dvPortGroupName = "<DistributedPortgroupName>"
$dvSwitch = Get-VDSwitch -Name $dvSwitchName
$dvPortGroup = Get-VDPortGroup -Name $dvPortGroupName -VDSwitch $dvSwitch
$securityPolicy=$dvPortGroup.ExtensionData.Config.DefaultPortConfig.SecurityPolicy
$macMgmtPolicy=$dvPortGroup.ExtensionData.Config.DefaultPortConfig.MacManagementPolicy
$securityPolicyResults = [pscustomobject] @{
DVPortgroup = $dvPortGroupName;
MacLearning =$macMgmtPolicy.MacLearningPolicy.Enabled;
NewAllowPromiscuous =$macMgmtPolicy.AllowPromiscuous;
NewForgedTransmits =$macMgmtPolicy.ForgedTransmits;
NewMacChanges =$macMgmtPolicy.MacChanges;
Limit =$macMgmtPolicy.MacLearningPolicy.Limit
LimitPolicy =$macMgmtPolicy.MacLearningPolicy.limitPolicy
LegacyAllowPromiscuous =$securityPolicy.AllowPromiscuous.Value;
LegacyForgedTransmits =$securityPolicy.ForgedTransmits.Value;
LegacyMacChanges =$securityPolicy.MacChanges.Value;
}
$securityPolicyResults 
