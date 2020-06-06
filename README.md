# PowerShell Core Profile

## PowerShell Core Profile Installation

`Install-Profile` installs module `PSDepend` and uses `Invoke-PSDepend` to
install the modules in [`profile.Depend.psd1`](profile.Depend.psd1).

```powershell
# Assume Documents\PowerShell does not exist.
$ProfileDir = Split-Path "$PROFILE"
git clone https://github.com/jfishe/PowerShell.git "$ProfileDir"

pushd $ProfileDir
.\Install-Profile.ps1
```

## PowerShell Core Installation and Update

[Installing PowerShell on Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows)
describes the Microsoft recommended method.

``` powershell
# Chocolatey can manage installation/updating.
choco install powershell-core `
  --install-arguments='"ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1
                        REGISTER_MANIFEST=1
                      "' `
  --packageparameters '"/CleanUpPath"'
```
