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

    Remove-Variable PSReadlineOptions
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
}

If ($host.Name -eq 'ConsoleHost') {
    $env:PROFILEDIR = Split-Path $PROFILE

    Import-Module -Name VimTabCompletion, DirColors, posh-git
    Update-DirColors ~\.dircolors

    $completionPath = "$env:PROFILEDIR/completion"
    # & starship init powershell --print-full-init |
    #   Out-File -Encoding utf8 -Path $env:PROFILEDIR\completion\starship-profile.ps1
    . "$completionPath/starship-profile"

    # & uv self update
    # & uv generate-shell-completion powershell |
    #   Out-File -Encoding utf8 -Path $env:PROFILEDIR\completion\uvShellCompletion.ps1
    . "$completionPath/uvShellCompletion"

    # condax completion
    # Modified from `condax --show-completion`
    # Delete PSReadLine settings.
    # $array = & condax --show-completion
    # $array[2..($array.Length-1)] |
    #   Out-File -Encoding utf8 -Path $env:PROFILEDIR\completion\condaxCompletion.ps1
    . "$completionPath/condaxCompletion"

    # PSBashCompletions
    if (($Null -ne (Get-Command bash -ErrorAction Ignore)) -or ($Null -ne (Get-Command git -ErrorAction Ignore))) {
        Import-Module PSBashCompletions
        $completionPath = "$env:PROFILEDIR/bash-completion"
        Register-BashArgumentCompleter pandoc "$completionPath/pandoc-completion.sh"
    }
    Remove-Variable completionPath, scriptblock
}


#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

