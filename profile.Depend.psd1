@{
    PSDependOptions   = @{
        AddToPath = $false
        Target    = 'CurrentUser'
    }
    'posh-git'        = 'latest'
    DirColors         = 'latest'
    Plaster           = 'latest'
    PSBashCompletions = 'latest'
    PSScriptAnalyzer  = 'latest'
    PSReadLine        = 'latest'
    VimTabCompletion  = @{
        Parameters       = @{
            AllowClobber = $true
        }
        VimTabCompletion = 'latest'
    }
    WslInterop        = 'latest'
}
