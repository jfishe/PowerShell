# PSReadline Settings
If ($host.Name -eq 'ConsoleHost') {
    $PSReadlineOptions = @{
        EditMode                      = "vi"
        BellStyle                     = "None"
        ViModeIndicator               = "Cursor"
        ShowToolTips                  = $true

        # History
        HistoryNoDuplicates           = $true
        HistorySearchCursorMovesToEnd = $true
        HistorySaveStyle              = "SaveIncrementally"
        MaximumHistoryCount           = 4000

        # Prediction
        PredictionSource              = "History"
        PredictionViewStyle           = "ListView"

        # Oh-My-Posh prompt
        ExtraPromptLineCount          = 1
        PromptText                    = "$([char]::ConvertFromUtf32(0x279C)) " # ➜

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

    $env:PROFILEDIR = Split-Path $PROFILE
}

If ($host.Name -eq 'ConsoleHost') {
    Import-Module VimTabCompletion
    Import-Module DirColors
    Update-DirColors ~\.dircolors
    Import-Module posh-git
    Invoke-Expression (&starship init powershell)
}
