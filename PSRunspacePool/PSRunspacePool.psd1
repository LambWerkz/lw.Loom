@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSRunspacePool.psm1'

# Version number of this module.
ModuleVersion = '1.0.0'

# Supported PSEditions
CompatiblePSEditions = @('Desktop', 'Core')

# ID used to uniquely identify this module
GUID = 'c46dedbf-1647-4977-8cd1-a776235247f5'

# Author of this module
Author = 'LambWerkz'

# Company or vendor of this module
CompanyName = 'LambWerkz'

# Copyright statement for this module
Copyright = '(c) 2023 LambWerkz. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A PowerShell module for managing Loom pools.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Functions to export from this module
FunctionsToExport = @('New-LoomPool', 'Get-LoomPool', 'Remove-LoomPool', 'Invoke-LoomCommand', 'Get-LoomCommand', 'Receive-LoomCommand', 'Stop-LoomCommand')

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess.
PrivateData = @{

    PSData = @{

        # Tags applied to this module.
        Tags = @('Loom', 'Pool', 'PowerShell')

    } # End of PSData hashtable

} # End of PrivateData hashtable

}