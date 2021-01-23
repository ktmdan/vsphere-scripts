Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 

$vmservers = Get-VM | Where-Object { $_.Name -like 'BlogUS1-*' }
Foreach ($vm in $vmservers) {
    $vm | Set-VM -MemoryMB 1024 -Confirm:$false
}