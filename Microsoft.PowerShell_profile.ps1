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
    }
    Set-PSReadLineOption @PSReadlineOptions
    # Disabled by default in vi mode
    Set-PSReadLineKeyHandler -Key 'Ctrl+w' -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar' -Function MenuComplete
    # Default Yellow/Cyan is low contrast
    $Host.PrivateData.ProgressForegroundColor = [ConsoleColor]::Red

    # condax completion
    # Modified from `condax --show-completion`
    # Import-Module PSReadLine
    # Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
    $scriptblock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        $Env:_CONDAX_COMPLETE = "complete_powershell"
        $Env:_TYPER_COMPLETE_ARGS = $commandAst.ToString()
        $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = $wordToComplete
        condax | ForEach-Object {
            $commandArray = $_ -Split ":::"
            $command = $commandArray[0]
            $helpString = $commandArray[1]
            [System.Management.Automation.CompletionResult]::new(
                $command, $command, 'ParameterValue', $helpString)
        }
        $Env:_CONDAX_COMPLETE = ""
        $Env:_TYPER_COMPLETE_ARGS = ""
        $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = ""
    }
    Register-ArgumentCompleter -Native -CommandName condax -ScriptBlock $scriptblock
}

If ($host.Name -eq 'ConsoleHost') {
    Function _history {
        Get-Content (Get-PSReadLineOption).HistorySavePath | less -N
    }
    Set-Alias -Name history -Value _history `
        -Description "Show PSReadline command history file with pager by less"

    Function _which {
        Get-Command -All $Args[0] -ErrorAction SilentlyContinue | Format-List
    }
    Set-Alias -Name which -Value _which `
        -Description "Get-Command -All <command>"


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
    Import-Module -Name VimTabCompletion, DirColors, posh-git
    Update-DirColors ~\.dircolors
    # Starship-profile is installation specific, so run once:
    # & starship init powershell --print-full-init |
    # Out-File -Encoding utf8 -Path $env:PROFILEDIR\starship-profile.ps1
    . $env:PROFILEDIR/starship-profile
}
