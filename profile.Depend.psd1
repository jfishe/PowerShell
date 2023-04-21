@{
    PSDependOptions  = @{
        AddToPath = $false
	Target = 'CurrentUser'
    }
    'posh-git'       = 'latest'
    Plaster          = 'latest'
    PSScriptAnalyzer = 'latest'
    WslInterop       = 'latest'
    PSReadLine       = 'latest'
    DirColors        = 'latest'
    VimTabCompletion = @{
	Parameters = @{
		AllowClobber = $true
	}
	VimTabCompletion = 'latest'
    }
}
