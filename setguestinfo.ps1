



Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67 -user admin@vsphere.local -password 

$wsdl = "http://devwd.wd.local/dataprovider/WDDataProvider.asmx?wsdl"

$vmservers = Get-VM | Where-Object { $_.Name -like 'WD-DIALER*' }

Foreach ($vm in $vmservers) {
    $name = $vm.Name
    $vm | new-advancedsetting -Name guestinfo.hostname -Value $name  -Force:$true -Confirm:$false
    $vm | new-advancedsetting -Name guestinfo.wsdl -Value $wsdl  -Force:$true -Confirm:$false

}