Add-PSSnapin Vmware*
Connect-VIServer -server vsphere67 -user admin@vsphere.local -password 
$report = foreach($vm in Get-VM){

    $vm | Select Name,@{N='VMX';E={$vm.ExtensionData.Config.Files.VmPathName.Split('/')[0]}},

    @{N='Swap';E={

        switch($vm.ExtensionData.Config.SwapPlacement){

            'inherit' {

                $parent = Get-View $vm.ExtensionData.ResourcePool -Property Name,Parent

                while($parent -isnot [VMware.Vim.ClusterComputeResource]){

                    $parent = Get-View $parent.Parent -Property Name,Parent

                }

                $parent = Get-View $parent.MoRef -Property ConfigurationEx.VmSwapPlacement

                switch($parent.ConfigurationEx.VmSwapPlacement){

                    'hostLocal' {

                        $esx = Get-View $vm.ExtensionData.Runtime.Host -Property Config.Local.SwapDatastore

                        $swapLocation = Get-View $esx.Config.LocalSwapDatastore -Property Name

                    }

                    'vmDirectory' {

                        $swapLocation = $vm.ExtensionData.Config.Files.VmPathName.Split('/')[0]

                    }

                }

            }

            'hostLocal' {

                $esx = Get-View $vm.ExtensionData.Runtime.Host -Property Config.Local.SwapDatastore

                $swapLocation = Get-View $esx.Config.LocalSwapDatastore -Property Name

            }

            'vmDirectory' {

                $swapLocation = $vm.ExtensionData.Config.Files.VmPathName.Split('/')[0]

            }

        }

        $swapLocation

    }},

    @{N='SwapSizeGB';E={

        $size = $_.ExtensionData.LayoutEx.File | where{$_.Type -eq 'swap'} | Select -ExpandProperty Size

        [math]::Round($size/1GB,1)

    }}

}
$report | Export-Csv -Path c:\temp\report.csv -NoTypeInformation -UseCulture