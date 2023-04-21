
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "$HOME\miniconda3\Scripts\conda.exe") {
    # (& "$HOME\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
    $Env:CONDA_EXE = "$HOME\miniconda3\Scripts\conda.exe"
    $Env:_CE_M = ""
    $Env:_CE_CONDA = ""
    $Env:_CONDA_ROOT = "$HOME\miniconda3"
    $Env:_CONDA_EXE = "$HOME\miniconda3\Scripts\conda.exe"
    $CondaModuleArgs = @{ChangePs1 = $True}
    Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

    conda activate base

    Remove-Variable CondaModuleArgs
}
#endregion

