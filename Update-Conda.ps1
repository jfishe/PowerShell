
<#PSScriptInfo

.VERSION 1.0

.GUID 33ec3675-15a6-4160-a06c-c04c1833cfce

.AUTHOR jdfenw@gmail.com

.COMPANYNAME John D. Fisher

.COPYRIGHT John D. Fisher, MIT License

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
Update conda env for base, vim_python and condax. Upgrade pipx.

#>
[cmdletbinding()]
Param()

$CondaEnvironment = (
        '-n base conda',
        '-n base --all',
        '-n vim_python --all'
        ).foreach({ [PSObject]@{Value = $_.Split()} })

foreach ($Item in $CondaEnvironment) {
    Write-Verbose "conda update $($Item.Value)"
    Invoke-Conda update $Item.Value
}

if ($Null -ne (Get-Command condax -ErrorAction Ignore)) {
    try {
        condax update --all
    }
    catch {"condax error"}
}

if ($Null -ne (Get-Command pipx -ErrorAction Ignore)) {
    try {
        pipx upgrade-all
    }
    catch {"pipx error"}
}
