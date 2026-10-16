# PowerShell Core Profile

## PowerShell Core Profile Installation

`Install-Profile` installs module `PSDepend` and uses `Invoke-PSDepend` to
install the modules in [`profile.Depend.psd1`](profile.Depend.psd1).

[Starship: Cross-Shell Prompt](https://starship.rs/) works well in Z-Shell,
PowerShell and PowerShell Core.

```powershell
# Assume Documents\PowerShell does not exist.
$ProfileDir = Split-Path "$PROFILE"
git clone https://github.com/jfishe/PowerShell.git "$ProfileDir"

if ($?) {
    pushd $ProfileDir
    git submodule update --init
    .\Install-Profile.ps1
} else {
    Write-Error -Message "Failed to install $ProfileDir"
}
```

## PowerShell Core Installation and Update

[Installing PowerShell on Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows)
describes the Microsoft recommended method.

```powershell
# Chocolatey can manage installation/updating.
choco install powershell-core `
  --install-arguments='"ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1
                        REGISTER_MANIFEST=1
                      "' `
  --packageparameters '"/CleanUpPath"'
```

## Opening a tab or pane in the same directory

[Tutorial: Opening a tab or pane in the same directory in Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-with-starship)
enables `duplicateTab` and `splitPane` to open in the current directory.

WindowsTerminal default `commandline` for `wsl` includes `--cd ~`,
which overrides the current directory.
Setting `"startingDirectory": "~"` opens in `$HOME`,
when `OSC9;9;` is not set to current directory.
