



Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 
$sOriginVM="TVM-Template"
$sOriginVMSnapshotName="clones2"
$sNewVMName="TVM-V"
$oVCenterFolder=(Get-VM $sOriginVM).Folder
$oSnapShot=(Get-Snapshot -VM $sOriginVM -Name $sOriginVMSnapshotName) 
$oESXDataStore=Get-Datastore -Name "VNX-Raid5-1-General"

$powercfg = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
$powercfg.standbyAction = "powerOnSuspend"

$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.powerOpInfo = $powercfg

$vmin = 1500
$vmax = 1599

For ($i=$vmin; $i -le $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    New-VM -Name $sNewVMNameExt -VM $sOriginVM -Location $oVCenterFolder -Datastore $oESXDataStore -VMHost "esxucs2-2"  -LinkedClone -ReferenceSnapshot $oSnapShot -RunAsync
    
}

Write-Host "---- Done creating VMs sleeping for 2 minutes to stablize"
Start-Sleep -s 120

For ($i=$vmin; $i -le $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    $vm = Get-VM -Name $sNewVMNameExt
    $vm.ExtensionData.ReconfigVM_Task($spec)    
    $vm | new-advancedsetting -Name guestinfo.hostname -Value $sNewVMNameExt -Force:$true -Confirm:$false
}


