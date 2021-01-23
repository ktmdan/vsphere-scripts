Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 
$vmservers = Get-VM | Where-Object { $_.Name -like 'TVM*' -and ($_.PowerState -eq 'Suspended' -or  $_.PowerState -eq 'PoweredOn')}
$vmservers | select Name,Host | export-csv c:\temp\TVMServers.csv -NoTypeInformation
#$vmservers | Stop-VMGuest -Confirm:$false 