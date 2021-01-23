Add-PSSnapin Vmware*
Connect-VIServer -server https://vsphere67/ -user admin@vsphere.local -password 
$sOriginVM="vicibox9-base"
$sOriginVMSnapshotName="clones"
$sNewVMName="V10-V"
#$sOriginVM="ViciDialerTemplate"
#$sOriginVMSnapshotName="BaseImage"
#$sNewVMName="VICI-VC0"
$oVCenterFolder=(Get-VM $sOriginVM).Folder
$oSnapShot=(Get-Snapshot -VM $sOriginVM -Name $sOriginVMSnapshotName) 
$oESXDataStore=Get-Datastore -Name "VNX-Raid5-1-General"
For ($i=118; $i -le 127; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    $oLinkedClone=New-VM -Name $sNewVMNameExt -VM $sOriginVM -Location $oVCenterFolder -Datastore $oESXDataStore -VMHost "esxucs2-6.trinity.secretwardialer.com"  -LinkedClone -ReferenceSnapshot $oSnapShot
}

#-ResourcePool Resources