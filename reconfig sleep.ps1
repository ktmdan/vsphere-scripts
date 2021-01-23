
#fix power to standby
$powercfg = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
$powercfg.standbyAction = "powerOnSuspend"

$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.powerOpInfo = $powercfg


#$vmservers = Get-VM | Where-Object { $_.Name -like 'TVM-V*' -and $_.PowerState -eq 'PoweredOn' }
#$vmservers | select Name,Host | export-csv c:\temp\reconfig.csv -NoTypeInformation


$allvmservers = Get-VM | Where-Object { $_.Name -like 'TVM-V5*'  }
For($i=0;$i -lt $allvmservers.Count;$i++) {
    $vm = $allvmservers[$i]
    $vm.ExtensionData.ReconfigVM_Task($spec)
}

#$vmservers = import-csv C:\temp\reconfig.csv | select -ExpandProperty name 

#Start-VM -VM $vmservers -RunAsync $true