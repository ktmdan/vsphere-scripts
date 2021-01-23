Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password  

Get-VM | Where-Object { $_.VMResourceConfiguration.htcoresharing -notlike 'Any'}