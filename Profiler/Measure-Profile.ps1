
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

 'Profile + prompt' also renders the prompt once, so work deferred to the
 first prompt (starship PreCommand and render) is included.

.PARAMETER Count
 Number of pwsh launches per case.

#>
Param(
    [ValidateRange(1, 1000)]
    [int]$Count = 20
)

$cases = [ordered]@{
    'NoProfile'        = { pwsh -NoProfile -Command 1 }
    'Profile'          = { pwsh -Command 1 2>$null }
    'Profile + prompt' = { pwsh -Command '$null = prompt' 2>$null }
}

$results = foreach ($case in $cases.GetEnumerator()) {
    $times = 1..$Count | ForEach-Object {
        Write-Progress -Id 1 -Activity $case.Key -PercentComplete (100 * $_ / $Count)
        (Measure-Command $case.Value).TotalMilliseconds
    }
    Write-Progress -Id 1 -Activity $case.Key -Completed
    $sorted = $times | Sort-Object
    [PSCustomObject]@{
        Case     = $case.Key
        MeanMs   = [math]::Round(($times | Measure-Object -Average).Average)
        MedianMs = [math]::Round($sorted[[int][math]::Floor(($Count - 1) / 2)])
    }
}

$baseline = $results[0].MeanMs
$results | Select-Object *, @{ Name = 'OverheadMs'; Expression = { $_.MeanMs - $baseline } }
