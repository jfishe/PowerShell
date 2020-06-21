<#PSScriptInfo

.VERSION 1.0

.GUID 934b2aba-e7bb-4b3e-83e6-7006c7411746

.AUTHOR John D. Fisher

.COMPANYNAME jdfenw@gmail.com

.COPYRIGHT Copyright (c) 2020 John D. Fisher

.TAGS

.LICENSEURI https://github.com/jfishe/PowerShell/blob/master/LICENSE

.PROJECTURI https://github.com/jfishe/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<#

.DESCRIPTION
 Link Windows Terminal settings.json

#>
[CmdletBinding()]
Param()

$Destination = Get-ChildItem `
    "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_*\" `
    -ErrorAction Stop
$Destination = "$Destination\LocalState\settings.json"

$Backup = $Destination -replace "`.json$", '.json.bak'

$Source = "$PSScriptRoot\settings.json"

Copy-Item "$Destination" "$Backup"
Remove-Item "$Destination"
& cmd.exe /c "mklink /H `"$Destination`" `"$Source`""
