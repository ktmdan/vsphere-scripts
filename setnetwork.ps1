

$allvmservers = Get-VM | Where-Object { $_.Name -like 'TVM-V4*'  }

For($i=0;$i -lt $allvmservers.Count;$i++) {
    $vm = $allvmservers[$i]
    $vm | Get-NetworkAdapter | Where {$_.NetworkName -eq "PhoneRemote160"}  | set-networkadapter -NetworkName "PhoneRemote160-ephemeral" -confirm:$false -RunAsync:$true    
}
