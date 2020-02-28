# PSReadline Settings
If ($host.Name -eq 'ConsoleHost') {
    Set-PSReadlineOption -EditMode vi -BellStyle None `
        -ViModeIndicator Cursor `
        -ShowToolTips
    # Disabled by default in vi mode
    Set-PSReadLineKeyHandler -Key 'Ctrl+w' -Function BackwardDeleteWord
    # History
    Set-PSReadLineOption -HistoryNoDuplicates `
        -HistorySearchCursorMovesToEnd `
        -HistorySaveStyle SaveIncrementally `
        -MaximumHistoryCount 4000
}

Function _which {
    Get-Command -All $Args[0] -ErrorAction SilentlyContinue | Format-List
}
Set-Alias -Name which -Value _which

Function Set-ColorScheme {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param()
    begin {
        $colortool = Get-Command -Name "colortool"
        $ColorSchemes = $colortool.Path |
            ForEach-Object -Process {(Get-Item $_).Directory} |
            ForEach-Object -Process {Get-ChildItem $_ -Name "schemes/solarized.*"}
        $colorscheme = [int]$(($env:COLORSCHEME -eq 0))
        $ConfirmMessage = @("Change console color scheme to",
            $ColorSchemes[$colorscheme]
            )
    }
    process {
        if ($PSCmdlet.ShouldProcess($ConfirmMessage)) {
            $env:COLORSCHEME = $colorscheme
            & $colortool --quiet $ColorSchemes[$env:COLORSCHEME]
        }
    }
<#
.SYNOPSIS

Toggle the console color scheme between solarized dark and light.

.DESCRIPTION

Windows Console ColorTool should be in $env:PATH.

The schemes\ folder should be in the same directory as ColorTool.exe.

The color schemes, based on vim-solarized8, were created using terminal.sexy.

.OUTPUTS

ColorTool.exe --quiet [[solarized.dark.itermcolors]|[solarized.light].itermcolors]

.LINK

https://github.com/Microsoft/console/tree/master/tools/ColorTool

.LINK

https://terminal.sexy/

.LINK

https://github.com/lifepillar/vim-solarized8

#>
}
Set-Alias -Name yob -Value Set-ColorScheme

#
If ($host.Name -eq 'ConsoleHost') {
    Import-WslCommand "less", "ls", "grep", "tree"
    $WslDefaultParameterValues = @{
        less = '-R --ignore-case'
        ls = '-AFh --color=auto --group-directories-first'
        grep = '--color=auto'
    }
    $env:PROFILEDIR = (Get-Item $PROFILE).Directory
}

# Import-Module posh-git and configure prompt.
# 400 msec
If ($host.Name -eq 'ConsoleHost') {
    . $PSScriptRoot\posh-gitrc.ps1
}
