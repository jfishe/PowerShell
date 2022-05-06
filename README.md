# PowerShell Core Profile

## PowerShell Core Profile Installation

`Install-Profile` installs module `PSDepend` and uses `Invoke-PSDepend` to
install the modules in [`profile.Depend.psd1`](profile.Depend.psd1).

[Starship: Cross-Shell Prompt](https://starship.rs/) works well in zsh,
powershell and pwsh.

```powershell
# Assume Documents\PowerShell does not exist.
$ProfileDir = Split-Path "$PROFILE"
git clone https://github.com/jfishe/PowerShell.git "$ProfileDir"

if ($?) {
    pushd $ProfileDir

    # Install `direcolors`.
    git submodule update --init
    cmd /c "mklink $HOME\.dircolors $ProfileDir\PowerShell\dircolors-solarized\dircolors.ansi-universal"

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

## Windows Terminal

### Windows Terminal Preview

```powershell
$PreviewSettingsJSON = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_*\LocalState\settings.json"
```

### Windows Terminal Release

```powershell
$SettingsJSON = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
```

[WindowsTerminal\Install-WindowsTerminalSettings.ps1](WindowsTerminal\Install-WindowsTerminalSettings.ps1)
links `$SettingsJSON` to
[WindowsTerminal\settings.json](WindowsTerminal\settings.json), saving the
current `settings.json` as `settings.json.bak`.
