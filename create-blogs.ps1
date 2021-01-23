



Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 
$sOriginVM="ubuntu-base"
$sOriginVMSnapshotName="base1gb"
$sNewVMName="BlogUS1-"
$oVCenterFolder=(Get-VM $sOriginVM).Folder
$oSnapShot=(Get-Snapshot -VM $sOriginVM -Name $sOriginVMSnapshotName) 
$oESXDataStore=Get-Datastore -Name "VNX-Raid5-1-General"


$vmin = 1005
$vmax = 1101

$linuxSpec = "BasicLinuxSpec"
$specClone = New-OSCustomizationSpec -Domain internal.local -OSType Linux  -DnsServer "8.8.8.8", "8.8.4.4" –Type NonPersistent 

#$osc =  Get-OSCustomizationSpec BasicLinuxSpec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIp -IpAddress 216.189.91.101 -SubnetMask 255.255.255.0 -DefaultGateway 216.189.91.1                       

For ($i=$vmin; $i -lt $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

   New-VM -Name $sNewVMNameExt -VM $sOriginVM -Location $oVCenterFolder -Datastore $oESXDataStore -VMHost "esxucs2-1.trinity.secretwardialer.com"  -LinkedClone -ReferenceSnapshot $oSnapShot -RunAsync
    
}

Write-Host "---- Done creating VMs sleeping for 2 minutes to stablize"
Start-Sleep -s 120

For ($i=$vmin; $i -lt $vmax; $i++) { 
    $sNewVMNameExt=$sNewVMName+$i

    $ip = "216.198.91.$($i-1000)"
    write-host "IP: $ip"
    $nicMapping = Get-OSCustomizationNicMapping –OSCustomizationSpec $specClone
    $nicMapping | Set-OSCustomizationNicMapping –IpMode UseStaticIP –IpAddress $ip –SubnetMask “255.255.252.0” –DefaultGateway “216.198.91.1”

    Set-VM -VM $sNewVMNameExt -OSCustomizationSpec $specClone -Confirm:$false
}


