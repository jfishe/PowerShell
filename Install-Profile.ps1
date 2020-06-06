[CmdletBinding()]
Param ()

Write-Output "Starting build of PowerShell Profile"

if (!(Get-PackageProvider -Name 'NuGet')) {
    Write-Output "Installing Nuget package provider..."
    Install-PackageProvider -Name 'NuGet' -Force -Confirm:$false | Out-Null
}

Write-Output "Install/Import Profile-Dependent Modules"
$PSDependVersion = '0.3.2'
if (!(Get-InstalledModule -Name 'PSDepend' -RequiredVersion $PSDependVersion `
            -ErrorAction 'SilentlyContinue')) {
    Install-Module -Name 'PSDepend' -RequiredVersion $PSDependVersion -Force `
        -Scope 'CurrentUser'
}
Import-Module -Name 'PSDepend' -RequiredVersion $PSDependVersion
Invoke-PSDepend -Path "$PSScriptRoot\profile.Depend.psd1" -Install
