



Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67 -user admin@vsphere.local -password 
$sOriginVM="WD-DIALER03"
$sOriginVMSnapshotName="wd-dialer2-master"
$sNewVMName="WD-DIALER2-0"
$oVCenterFolder=(Get-VM $sOriginVM).Folder
$oSnapShot=(Get-Snapshot -VM $sOriginVM -Name $sOriginVMSnapshotName) 
$oESXDataStore=Get-Datastore -Name "VNX-Raid5-1-General"


$vmin = 18
$vmax = 45

For ($i=$vmin; $i -le $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    New-VM -Name $sNewVMNameExt -VM $sOriginVM -Location $oVCenterFolder -Datastore $oESXDataStore -VMHost "esxucs2-2"  -LinkedClone -ReferenceSnapshot $oSnapShot -RunAsync
    
}

Write-Host "---- Done creating VMs sleeping for 60 seconds to stablize"
Start-Sleep -s 60
$wsdl = "http://devwd.wd.local/dataprovider/WDDataProvider.asmx?wsdl"

For ($i=$vmin; $i -le $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    $vm = Get-VM -Name $sNewVMNameExt    
    $vm | new-advancedsetting -Name guestinfo.hostname -Value $sNewVMNameExt -Force:$true -Confirm:$false
    $vm | new-advancedsetting -Name guestinfo.wsdl -Value $wsdl  -Force:$true -Confirm:$false
}

