Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password  
$LOG_FILE = "C:\machines.txt"
$VI_SERVER = "vsphere2"
get-vm | %{ $_ | select Name | out-file -filepath $LOG_FILE -append; $_ | Get-NetworkAdapter | out-file -filepath $LOG_FILE -append }


$report =@() 
Get-VM | Get-View | %{ 
 $VMname = $_.Name 
 $_.guest.net | %{
        $row = "" | Select VM, MAC
        $row.VM = $VMname 
        $row.MAC = $_.MacAddress 
        $report += $row 
  } 
  } 
$report | out-file -FilePath "c:\test.txt" -append