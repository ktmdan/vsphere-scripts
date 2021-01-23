#set ip address vapp variable
Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password  

#Get-VM -Name 'RPT7-V001'  | Get-VMGuestNetworkInterface -GuestUser admin -GuestPassword  
Get-VM -Name 'RPT7-V001'  | Invoke-VMScript -ScriptText "netsh interface ipv4 show addresses name='Local Area Connection 2'" -GuestUser admin -GuestPassword  
#Get-VM -Name 'RPT7-V001' | Get-NetworkAdapter | where {$_.NetworkName -eq 'PhoneRemote160'} | Set-NetworkAdapter -IPAddressAllocationMode  Manual