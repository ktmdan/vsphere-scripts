Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67  -user admin@vsphere.local -password  
$vmservers = Get-VM | Where-Object { $_.Name -like 'WD-DIALER*' -and $_.PowerState -eq 'PoweredOn' }
$vmservers | select Name,Host | export-csv c:\temp\wdservers.csv -NoTypeInformation
$vmservers | Stop-VMGuest -Confirm:$false