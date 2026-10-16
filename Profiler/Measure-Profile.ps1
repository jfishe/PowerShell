
<#PSScriptInfo

.VERSION 1.0

.GUID 9468f7e8-dfcd-45c5-ba37-a963de6548ec

.AUTHOR https://devblogs.microsoft.com/pwsh/author/slee

.COMPANYNAME Microsoft

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI https://devblogs.microsoft.com/pwsh/optimizing-your-profile/

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<#

.DESCRIPTION
 Compare average duration with and without Profile.

#>
Param()

$p = 0
1..100 | ForEach-Object {
    Write-Progress -Id 1 -Activity 'pwsh' -PercentComplete $_
    $p += (Measure-Command {
        pwsh -noprofile -command 1
    }).TotalMilliseconds
}
Write-Progress -id 1 -Activity 'profile' -Completed
$p = $p/100
Write-Output "$p Milliseconds"

$a = 0
1..100 | ForEach-Object {
    Write-Progress -Id 1 -Activity 'profile' -PercentComplete $_
    $a += (Measure-Command {
        pwsh -command 1
    }).TotalMilliseconds
}
Write-Progress -id 1 -activity 'profile' -Completed
Write-Output "$($a/100 - $p) Milliseconds Profile"
