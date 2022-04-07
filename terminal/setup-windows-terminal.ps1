echo '### ATENCAO: Ao final do script instale as fontes "FantasqueSansMono Nerd Font" na janela do explorer que abrirA.'
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

echo 'Tentando criar link simbólico para a configuração do Windows Terminal...' 
$StorePackages = "C:\Users\$env:UserName\AppData\Local\Packages\*Microsoft.WindowsTerminal*"
$WindowsTerminalDir = Get-ChildItem $StorePackages -ErrorAction SilentlyContinue
if ($WindowsTerminalDir) {
    echo 'Configurando o Windows Terminal com arquivo settings.xml'  
    Add-Symlink "${WindowsTerminalDir}\LocalState\settings.json" "C:\Users\$env:UserName\.dotfiles\dotfiles-windows\terminal\settings.json" > $null
    echo 'Feito!' 

    if (!(Test-Path -Path "C:\wsl\fonts")) {
        Set-Location -Path C:\
        md wsl/fonts
        #Set-Location -Path "C:\wsl\fonts"        
    }

    echo 'Fazendo download das fontes necessárias...'    
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FantasqueSansMono.zip" -OutFile "C:\wsl\fonts\FantasqueSansMono.zip"        
    echo 'Extraindo fonte...'    
    Expand-Archive "C:\wsl\fonts\FantasqueSansMono.zip" -DestinationPath "C:\wsl\fonts\FantasqueSansMono"
    Remove-Item "C:\wsl\fonts\FantasqueSansMono.zip"
    start "C:\wsl\fonts\FantasqueSansMono"

    echo '### Concluído'
    echo 'Instale as fontes 'Fantasque Sans Mono Regular Nerd Font Complete.ttf',  e reinicie o terminal'

} else {
    echo "Ocorreu um erro. Verifique se o windows terminal está instalado."
}

#if ((Test-Path -Path "C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState")) {
#    echo 'Configurando o Windows Terminal com arquivo settings.xml'    
#    echo 'Enviando settings.json para pasta de configuracao WT...' 
    #Copy-Item "C:\Users\$env:UserName\.dotfiles\dotfiles-windows\terminal\settings.json" -Destination "C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

#    if (!(Test-Path -Path "C:\wsl\fonts")) {
#        Set-Location -Path C:\
#        md wsl/fonts
        #Set-Location -Path "C:\wsl\fonts"        
 #   }

 #   echo 'Fazendo download da fonte...'    
 #   Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FantasqueSansMono.zip" -OutFile "C:\wsl\fonts\FantasqueSansMono.zip"        
 #   echo 'Extraindo fonte...'    
 #   Expand-Archive "C:\wsl\fonts\FantasqueSansMono.zip" -DestinationPath "C:\wsl\fonts\FantasqueSansMono"
 #   Remove-Item "C:\wsl\fonts\FantasqueSansMono.zip"
 #   start "C:\wsl\fonts\FantasqueSansMono"
#} 

