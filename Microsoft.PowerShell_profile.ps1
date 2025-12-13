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
}

If ($host.Name -eq 'ConsoleHost') {
    $env:PROFILEDIR = Split-Path $PROFILE
    $completionPath = "$env:PROFILEDIR\Completions"
    . "$completionPath/Profile.Completions"

    $WslDefaultParameterValues = @{
        less = '-R --ignore-case'
        ls   = '-AFh --color=auto --group-directories-first'
        grep = '--color=auto'
    }
    Import-WslCommand "less", "ls", "grep", "tree", "diff"

    # & starship init powershell --print-full-init |
    #   Out-File -Encoding utf8 -Path $env:PROFILEDIR\completion\starship-profile.ps1
    if (Get-Command 'starship' -ErrorAction SilentlyContinue) {
        # Update-DirColors ~\.dircolors
        $Env:LS_COLORS = 'cd=37;44:ln=35:ex=01;31:sg=30;43:do=35;44:bd=33;44:mh=0:or=05;37;41:rs=0:tw=30;42:ow=34;42:mi=05;37;41:no=00:ca=30;41:st=37;44:di=36:su=37;41:pi=30;44:so=35;44:fi=00:*~=01;32:*#*#=01;34:*.emf=33:*.rtf=31:*.iso=1;35:*.scss=32:*.enc=34:*.h=32:*.cgm=33:*.mov=33:*.au=33:*.c=32:*.midi=33:*.6=32:*.bz=1;35:*.jar=1;35:*.dmg=1;35:*.zip=1;35:*.off=01;36:*.xbm=33:*#.bak=01;33:*.db=34:*.nuv=33:*.ots=31:*.ppm=33:*.webp=33:*.pps=33:*.8=32:*.cxx=32:*.bash=32:*.v=32:*.txt=32:*.rm=33:*.1=32:*#.org_archive=01;33:*.flac=33:*.csh=32:*.png=33:*.7=32:*.rpm=1;35:*.cc=32:*.ogg=33:*.pl=32:*.ANSI-01;32-brgreen=01;32:*.org=32:*.m4a=33:*.wmv=33:*.ra=33:*.apk=1;35:*.mpa=33:*.bak=01;36:*.ogm=33:*.tif=33:*.dvi=33:*.rar=1;35:*.swo=01;36:*.tar=1;35:*.md=32:*.aac=33:*.dist=01;36:*.ogx=33:*.ANSI-32-green=32:*.opus=33:*.ott=31:*.ANSI-33-yellow=33:*.0=32:*.flv=33:*.eps=33:*.js=32:*.z=1;35:*.pod=32:*.lua=32:*.doc=31:*.mng=33:*.xpi=1;35:*.rb=32:*.haml=32:*.pptx=31:*.4=32:*.java=32:*.xpm=33:*.2=32:*.mp3=33:*.pbm=33:*.aes=34:*.orig=01;36:*.ppsx=33:*.msi=1;35:*.mp4=33:*.ANSI-01;30-brblack=01;30:*.heic=33:*.tiff=33:*.sqlite=34:*.fla=31:*.exe=01;31:*.mp4v=33:*.l=32:*.go=32:*.zsh=32:*.otp=31:*.el=32:*.zst=1;35:*.gpg=34:*.xls=31:*.csv=32:*.gl=33:*.objc=32:*.hpp=32:*#############################################################################=:*.cpp=32:*.tbz=1;35:*.sh=32:*.m4v=33:*.flc=33:*.pcx=33:*.jpg=33:*.wav=33:*###=Misc:*.arj=1;35:*.vob=33:*.odp=31:*.ANSI-01;33-bryellow=01;33:*#*~=01;34:*.php=32:*.webm=33:*.bib=32:*.xwd=33:*.pdf=31:*.sv=32:*.ANSI-01;36-brcyan=01;36:*.tgz=1;35:*#.old=01;33:*.pm=32:*.ods=31:*.mka=33:*.ANSI-01;35-brmagenta=01;35:*.docx=31:*.gem=1;35:*#.off=01;33:*.app=01;31:*.shtml=32:*.fli=33:*.mkd=32:*.svh=32:*.ppt=31:*.dot=31:*#*,v=01;33:*.ANSI-31-red=31:*.dotx=31:*.bin=1;35:*.hs=32:*.ANSI-30-black=30:*.mid=33:*.3=32:*.pgm=33:*.yuv=33:*#.swo=01;33:*.gz=1;35:*,v=01;36:*.sql=32:*.7z=1;35:*.swf=33:*.war=1;35:*.xlsx=31:*.m2v=33:*#.dist=01;33:*.xml=32:*.less=32:*.swp=01;36:*.qt=33:*.p=32:*.tbz2=1;35:*.gif=33:*.bat=01;31:*.asf=33:*.axv=33:*.9=32:*.tga=33:*.sass=32:*#.orig=01;33:*.ANSI-01;37-brwhite=01;37:*.svgz=33:*.man=32:*.org_archive=01;36:*.reg=01;31:*#=custom:*.tex=32:*.dl=33:*.old=01;36:*.asc=34:*.rmvb=33:*.avi=33:*.coffee=32:*.xz=1;35:*.3des=34:*.deb=1;35:*.ANSI-35-magenta=35:*.ogv=33:*#.swp=01;33:*.bmp=33:*.rdf=32:*.n=32:*.log=01;32:*.ANSI-37-white=37:*.erb=32:*.ANSI-36-cyan=36:*.vim=32:*.psd=31:*.html=32:*.py=32:*.htm=32:*.cmd=01;31:*.tx=1;35:*.xcf=33:*.cl=32:*.pgp=34:*.ANSI-01;31-brred=01;31:*.vh=32:*.jpeg=33:*.bz2=1;35:*.vhd=32:*#.log=01;34:*.com=01;31:*.5=32:*.mpeg=33:*.cab=1;35:*.mpg=33:*.ps=33:*.css=32:*.mkv=33:*.anx=33:*.NEF=33:*.svg=33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.odt=31:*.avif=33'

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
