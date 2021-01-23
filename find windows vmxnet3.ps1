Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 
Get-VM | 
Where-Object {$_.OSFullName -like "*Windows Server*" } |

Get-NetworkAdapter | 
Where-object {$_.Type -eq "Vmxnet3"} | 
Select @{N="VM";E={$_.Parent.Name}},Name,Type 