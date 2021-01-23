Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67  -user admin@vsphere.local -password  
$vmservers = import-csv C:\temp\wdservers.csv | select -ExpandProperty name
Start-VM -VM $vmservers
