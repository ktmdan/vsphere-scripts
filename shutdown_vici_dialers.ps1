Add-PSSnapin Vmware*
Connect-VIServer -server vsphere -user admin@vsphere.local -password 
$vmservers = Get-VM | Where-Object { $_.Name -like 'VICI-*' -and $_.PowerState -eq 'PoweredOn' }
$vmservers | select Name,Host | export-csv c:\temp\viciservers.csv -NoTypeInformation
$vmservers | Stop-VMGuest -Confirm:$false