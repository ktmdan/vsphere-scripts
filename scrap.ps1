
$sqlCommand = "SELECT assignedDevice  FROM [WebReg].[dbo].[FBAccount]  where isArchived = 1 and assignedDevice <> ''"

#$connectionString = "Data Source=Server=10.12.2.11,1433;Integrated Security=SSPI;Initial Catalog=WebReg"
$connectionString = 'Data Source=10.10.66.51,1433;Initial Catalog=WebReg;User ID=sa;Password=;'

$connection = new-object system.data.SqlClient.SQLConnection($connectionString)
$command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
$connection.Open()

$adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
$dataset = New-Object System.Data.DataSet
$adapter.Fill($dataSet) | Out-Null

$connection.Close()
#$dataSet.Tables

$archivedVMs = New-Object System.Collections.ArrayList

Foreach ($r in $dataSet.Tables[0].Rows) {
    $devicename = $r[0] #V731-98025
    $s = $devicename.Split("-")[0]    
    $archivedVMs.Add("TVM-$s") | Out-Null
}

Add-PSSnapin Vmware*
Connect-VIServer -server vsphere2 -user admin@vsphere.local -password 
$vmservers = Get-VM | Where-Object { $_.Name -like 'TVM-*'  } | Select -Expand Name
#$vmservers 

Foreach ($avm in $archivedVMs) {
    if($vmservers -contains $avm) {
        Write-Host "FOUND $avm"
        #if($avm.PowerState -eq "PoweredOn") {
            Stop-VM -VM $avm -Confirm:$false | Out-Null
        #}
        Remove-VM $avm -DeletePermanently -Confirm:$false -RunAsync  | Out-Null
    } else {
        Write-Host "NOT FOUND $avm"
    }
}

