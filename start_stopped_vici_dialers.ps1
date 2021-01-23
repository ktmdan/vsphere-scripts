Add-PSSnapin Vmware*
Connect-VIServer -server vsphere -user admin@vsphere.local -password 
#$username = "root"
#$password = ""
#$secstr = New-Object -TypeName System.Security.SecureString
#$password.ToCharArray() | foreach {$secstr.AppendChar($_)}
#$cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList $username, $secstr
#import-csv C:\temp\viciservers.csv | foreach { $vm = Get-VMHost -Name $_.host; $vm | fl }
#import-csv C:\temp\viciservers.csv | foreach { Start-VM -VM "$($_.name)" -Server "$($_.host)" }
$vmservers = import-csv C:\temp\viciservers.csv | select -ExpandProperty name
Start-VM -VM $vmservers
