Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password  
$vmservers = @("Vici2-Web01","Vici3-Web01","Vici4-Web01","Vici5-Web01","Vici6-Web01","Vici7-Web01","Vici8-Web01")
Start-VM -VM $vmservers
