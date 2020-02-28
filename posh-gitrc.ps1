# http://joonro.github.io/blog/posts/powershell-customizations.html#posh-git-and-prompt-Customization
# http://serverfault.com/questions/95431

function prompt {
    # https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt

    $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
    $GitPromptSettings.DefaultPromptWriteStatusFirst = $true

    $prompt = ''
    if ($env:CONDA_PROMPT_MODIFIER) {
        $prompt += Write-Prompt $env:CONDA_PROMPT_MODIFIER
    }
    $prompt += Write-Prompt "$env:USERNAME@"  -ForegroundColor DarkYellow
    $prompt += Write-Prompt "$env:COMPUTERNAME"  -ForegroundColor Magenta
    $prompt += Write-Prompt " : $($PSVersionTable.PSEdition) : "  -ForegroundColor DarkGray
    $prompt += & $GitPromptScriptBlock
    if ($prompt) { "$prompt " } else { " " }
}

Import-Module posh-git
