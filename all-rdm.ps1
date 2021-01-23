## Get all VMs with RDM volumes

Add-PSSnapin Vmware*
Connect-VIServer -server vsphere  -user admin@vsphere.local -password 

Get-VM | Get-HardDisk | Where-Object {$_.DiskType -like “Raw*”} | 
Select @{N=”VMName”;E={$_.Parent}},Name,DiskType,@{N=”LUN_ID”;E={$_.ScsiCanonicalName}},@{N=”VML_ID”;E={$_.DeviceName}},Filename,CapacityGB | 
Export-Csv C:\temp\RDM-list.csv -NoTypeInformation