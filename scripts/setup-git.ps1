
echo 'Configurando o Git para Windows' 
if ((Test-Path -Path "C:\Users\$env:UserName\.dotfiles\stow\git")) {
    #Copy-Item C:\Users\$env:UserName\.dotfiles\stow\git\.gitconfig -Recurse C:\Users\$env:UserName\.gitconfig -Force
    
    #New-Item -ItemType SymbolicLink -Path C:\Users\$env:UserName\.dotfiles\stow\git\.gitconfig -Target C:\Users\$env:UserName\.gitconfig -Force
}

if ((Test-Path -Path "C:\Users\$env:UserName\.dotfiles\stow\ssh\.ssh")) {
    echo 'Pegando ssh'
    if (!(Test-Path -Path "C:\Users\$env:UserName\.ssh")) {        
        New-Item -Path C:\Users\$env:UserName\.ssh -ItemType Directory
    }

    #Copy-Item C:\Users\$env:UserName\.dotfiles\stow\ssh\.ssh -Recurse C:\Users\$env:UserName\.ssh -Force
    New-Item -ItemType SymbolicLink -Path C:\Users\$env:UserName\.dotfiles\stow\ssh\.ssh -Target C:\Users\$env:UserName\.ssh -Force
}


