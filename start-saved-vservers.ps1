Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 

$vmservers = import-csv C:\temp\TVMServers.csv | select -ExpandProperty name #| % {$_.replace("RPT7-","TVM-")}
#$vmservers
#Stop-VM -VM $vmservers



for($i=1;$i -le $vmservers.Count; $i++) {
    Start-VM -VM $vmservers[$i] -RunAsync 
    if($i % 10 -eq 0 ) {
        Write-Host "Waiting for start, Sleeping at $i for 90sec"
        Start-Sleep -s 90
        for($i2=$i-9;$i2 -le $i; $i2++) {
            Restart-VMGuest -VM $vmservers[$i2] -Confirm:$false 
        }
        Write-Host "Waiting for guest restart, Sleeping at $i for 90sec"
        Start-Sleep -s 100
        for($i2=$i-9;$i2 -le $i; $i2++) {
            Suspend-VM -VM $vmservers[$i2] -Confirm:$false -RunAsync 
        }
    }
}
