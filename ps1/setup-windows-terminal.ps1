echo '### ATENCAO: Install fonts "FantasqueSansMono Nerd Font" in the explorer window that will open'
echo '---------'
echo '---------'

function Add-Symlink {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$from,
        [Parameter(Mandatory)]
        [string]$to
    )

    New-Item -ItemType SymbolicLink -Path $from -Target $to -Force
}

echo 'Trying create a symbolic link for Windows Terminal...' 
$StorePackages = "C:\Users\$env:UserName\AppData\Local\Packages\*Microsoft.WindowsTerminal*"
$WindowsTerminalDir = Get-ChildItem $StorePackages -ErrorAction SilentlyContinue
if ($WindowsTerminalDir) {
    echo 'Configurando o Windows Terminal com arquivo settings.xml'  
    Add-Symlink "${WindowsTerminalDir}\LocalState\settings.json" "C:\Users\$env:UserName\dotfiles-windows\terminal\settings.json" > $null
    echo 'Feito!' 

    if (!(Test-Path -Path "C:\wsl\fonts")) {
        Set-Location -Path C:\
        md wsl/fonts
        #Set-Location -Path "C:\wsl\fonts"        
    }

    echo 'Configuring starship...'    
    New-Item -Path C:\Users\$env:UserName\.config -ItemType Directory -Force
    Add-Symlink "C:\Users\$env:UserName\.config\starship.toml" "C:\Users\$env:UserName\dotfiles-windows\terminal\starship.toml" > $null

    echo 'downloading fonts...'    
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FantasqueSansMono.zip" -OutFile "C:\wsl\fonts\FantasqueSansMono.zip"        
    echo 'Extraindo fonte...'    
    Expand-Archive "C:\wsl\fonts\FantasqueSansMono.zip" -DestinationPath "C:\wsl\fonts\FantasqueSansMono"
    Remove-Item "C:\wsl\fonts\FantasqueSansMono.zip"
    start "C:\wsl\fonts\FantasqueSansMono"

    echo '### Done'
    echo 'Install Fantasque Sans Mono Regular Nerd Font Complete.ttf fonts and restart Windows Terminal'

} else {
    echo "An error has occurred. Please verify windows terminal instalation."
}
