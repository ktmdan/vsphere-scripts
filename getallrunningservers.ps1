Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67  -user admin@vsphere.local -password 
$vmservers = Get-VM | Where-Object { $_.PowerState -eq 'PoweredOn' }
$vmservers | select Name,Host #| export-csv c:\temp\allrunningservers.csv -NoTypeInformation