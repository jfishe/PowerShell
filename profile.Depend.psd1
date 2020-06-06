@{
    PSDependOptions  = @{
        # Target    = '$DependencyFolder/_build_dependencies_/'
        Target    = CurrentUser
        AddToPath = $false
    }
    'posh-git'       = 'latest'
    'oh-my-posh'     = 'latest'
    Plaster          = 'latest'
    PSScriptAnalyzer = 'latest'
    WslInterop       = 'latest'
    PSReadLine       = 'latest'
}
