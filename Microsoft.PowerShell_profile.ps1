# PSReadline Settings
If ($host.Name -eq 'ConsoleHost') {
    Set-PSReadlineOption -EditMode vi -BellStyle None `
        -ViModeIndicator Cursor `
        -ShowToolTips `
        -PromptText "$([char]::ConvertFromUtf32(0x279C)) "

    # Disabled by default in vi mode
    Set-PSReadLineKeyHandler -Key 'Ctrl+w' -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete

    # History
    Set-PSReadLineOption -HistoryNoDuplicates `
        -HistorySearchCursorMovesToEnd `
        -HistorySaveStyle SaveIncrementally `
        -MaximumHistoryCount 4000

    # Prediction
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -Colors @{ Prediction = "`e[95m" } -ErrorAction SilentlyContinue

    Function _history {
        Get-Content (Get-PSReadLineOption).HistorySavePath | less -N
    }
    Set-Alias -Name history -Value _history `
        -Description "Show PSReadline command history file with pager by less"

    # Default Yellow/Cyan is low contrast
    $Host.PrivateData.ProgressForegroundColor = [ConsoleColor]::Red
}

Function _which {
    Get-Command -All $Args[0] -ErrorAction SilentlyContinue | Format-List
}
Set-Alias -Name which -Value _which `
    -Description "Get-Command -All <command>"

Function Set-ColorScheme {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param()
    begin {
        $colortool = Get-Command -Name "colortool"
        $ColorSchemes = $colortool.Path |
        ForEach-Object -Process { (Get-Item $_).Directory } |
        ForEach-Object -Process { Get-ChildItem $_ -Name "schemes/solarized.*" }
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

If ($host.Name -eq 'ConsoleHost') {
    # Remove cache if bash complete changes.
    #   $Env:APPDATA\PowerShell WSL Interop\WslCompletionFunctions
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $WslDefaultParameterValues = @{
        less = '-R --ignore-case'
        ls   = '-AFh --color=auto --group-directories-first'
        grep = '--color=auto'
    }
    Import-WslCommand "less", "ls", "grep", "tree", "diff"

    $env:PROFILEDIR = (Get-Item $PROFILE).Directory
}

# Import-Module posh-git and configure prompt.
# 400 msec
If ($host.Name -eq 'ConsoleHost') {
    . $PSScriptRoot\posh-gitrc.ps1
}
