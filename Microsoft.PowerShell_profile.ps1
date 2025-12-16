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

    Function _gitbash {
        $Parameters = @{
            # less = @('--RAW-CONTROL-CHARS', '--ignore-case')
            # See $env:LESS
            ls = @('-AFh', '--color=auto', '--group-directories-first')
            grep = @('--color=auto')
        }
        $Name = $MyInvocation.InvocationName
        $Options = $Parameters[$Name]
        & $(Get-Command -Name $Name -CommandType Application) @Options @Args
    }
    Set-Alias -Name ls -Value _gitbash -Description "GNU ls"
    Set-Alias -Name grep -Value _gitbash -Description "GNU grep"
}

If ($host.Name -eq 'ConsoleHost') {
    $env:PROFILEDIR = Split-Path $PROFILE
    $completionPath = "$env:PROFILEDIR\Completions"
    . "$completionPath/Profile.Completions"

    # & starship init powershell --print-full-init |
    #   Out-File -Encoding utf8 -Path $env:PROFILEDIR\completion\starship-profile.ps1
    if (Get-Command 'starship' -ErrorAction SilentlyContinue) {
        # Update-DirColors ~\.dircolors
        # Copy $Env:LS_COLORS to User Environment.

        function Invoke-Starship-PreCommand {
            if ($global:profile_initialized -ne $true) {
                $global:profile_initialized = $true

                Import-Module -Name DirColors -Global -DisableNameChecking
                Import-Module -Global -DisableNameChecking -Name posh-git, git-aliases

                Initialize-Profile
            }
        }
        # Invoke-Expression (&starship init powershell)
        . "$completionPath/starship-profile"
    }

    Remove-Variable completionPath
}
