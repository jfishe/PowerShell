
<#PSScriptInfo

.VERSION 1.0

.GUID 934b2aba-e7bb-4b3e-83e6-7006c7411746

.AUTHOR John D. Fisher

.COMPANYNAME jdfenw@gmail.com

.COPYRIGHT John D. Fisher All Rights Reserved

.TAGS

.LICENSEURI

.PROJECTURI

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

$Destination = "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$Backup = $Destination -replace "`.json$", '.json.bak'
$Source = "$PSScriptRoot\settings.json"

Copy-Item "$Destination" "$Backup"
Remove-Item "$Destination"
& cmd.exe /c "mklink /H `"$Destination`" `"$Source`""
