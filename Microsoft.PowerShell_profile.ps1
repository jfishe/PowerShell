# PSReadline Settings
If ($host.Name -eq 'ConsoleHost') {
    $PSReadlineOptions = @{
        EditMode = "vi"
        BellStyle = "None"
        ViModeIndicator = "Cursor"
        ShowToolTips = $true

        # History
        HistoryNoDuplicates = $true
        HistorySearchCursorMovesToEnd = $true
        HistorySaveStyle = "SaveIncrementally"
        MaximumHistoryCount = 4000

        # Prediction
        PredictionSource = "History"
        PredictionViewStyle = "ListView"

        # Oh-My-Posh prompt
        ExtraPromptLineCount = 1
        PromptText = "$([char]::ConvertFromUtf32(0x279C)) " # ➜

        # Colors = @{
        #     "InlinePredictionColor" = "`e[95m"
        #     "ListPredictionColor" = "`e[95m"
        #     "ListPredictionSelectedColor" = "`e[48;95m"
        # }
    }
    Set-PSReadLineOption @PSReadlineOptions
    # Disabled by default in vi mode
    Set-PSReadLineKeyHandler -Key 'Ctrl+w' -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete


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

If ($host.Name -eq 'ConsoleHost') {
    (@(&"C:/Users/jdfen/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe" --print-init --shell=pwsh --config="C:\Users\jdfen\iterm2.omp.json") -join "`n") | Invoke-Expression
    Import-Module VimTabCompletion
    Import-Module DirColors
    Update-DirColors ~\.dircolors
    Import-Module posh-git
    Invoke-Expression (&starship init powershell)
}

