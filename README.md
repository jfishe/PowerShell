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

`WindowsTerminal` does not distinguish
`Shift+Enter` (`\u001b[13;2u`) or
`Ctrl+Enter` (`\u001b[13;5u`), and
reserves `Alt+Enter` for `Toggle fullscreen`.
[Reddit user desgreech posted a solution to r/neovim](https://www.reddit.com/r/neovim/comments/14rwpi2/windows_terminal_ccr_keymap_not_working/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)
using `sendInput`.
The `JSON` schema splits actions and keys now,
so modify the solution accordingly in `settings.json`.

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

### WindowsTerminal JSON Fragment Extensions

- [Windows Terminal Json Fragment Extensions](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions)

### Opening a tab or pane in the same directory

[Tutorial: Opening a tab or pane in the same directory in Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-with-starship)
enables `duplicateTab` and `splitPane` to open in the current directory.

WindowsTerminal default `commandline` for `wsl` includes `--cd ~`,
which overrides the current directory.
Setting `"startingDirectory": "~"` opens in `$HOME`,
when `OSC9;9;` is not set to current directory.
