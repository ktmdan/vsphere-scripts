Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67 -user admin@vsphere.local -password 
get-cddrive -VM * | where {$_.IsoPath -ne $null} | select Parent,IsoPath

