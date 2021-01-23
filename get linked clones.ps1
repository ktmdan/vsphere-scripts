Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67  -user admin@vsphere.local -password 
function Get-LinkedClone {
   #The following line is a fast replacement for:  $vms = get-vm args[0] | get-view
   if( $args[0] -eq $null ) {
      $vms = Get-View -ViewType VirtualMachine -Property Name,Summary,Config.Hardware.Device
   } else {
      $vms = Get-View -ViewType VirtualMachine -Property Name,Summary,Config.Hardware.Device -Filter @{Name = $args[0]}
   }
 
   $linkedClones = @()
   foreach ($vm in $vms) {
      $unshared = $vm.Summary.Storage.Unshared
      $committed = $vm.Summary.Storage.Committed
      $ftInfo = $vm.Summary.Config.FtInfo
 
      if ( ($unshared -ne $committed) -and (($ftInfo -eq $null) -or ($ftInfo.InstanceUuids.Length -le 1)) ){
         # then $vm is a linked clone. 
 
         # Find $vm's base disks.
         $baseDisks = @()
         foreach ($d in $vm.Config.Hardware.Device) {
            $backing = $d.backing
            if ($backing -is [VMware.Vim.VirtualDeviceFileBackingInfo] -and $backing.parent -ne $null) {
               do {
                  $backing = $backing.parent
               } until ($backing.parent -eq $null)
               $baseDisks += $backing.fileName
 
            }
         }
 
         $linkedClone = new-object PSObject
         $linkedClone | add-member -type NoteProperty -Name Name -Value $vm.name
         $linkedClone | add-member -type NoteProperty -Name BaseDisks -Value $baseDisks
         $linkedClones += $linkedClone
      }
      #else { do nothing for VMs that are not linked clones }
   }
 
   $linkedClones | sort BaseDisks, Name
}

Get-LinkedClone |
Select Name,@{N='BaseDisks';E={$_.BaseDisks -join '|'}} |

Export-Csv -Path c:\temp\linkedclones.csv -NoTypeInformation -UseCulture