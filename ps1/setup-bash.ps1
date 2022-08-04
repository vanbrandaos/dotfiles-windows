function Add-Symlink {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$to,
        [Parameter(Mandatory)]
        [string]$from
    )
    New-Item -ItemType SymbolicLink -Path $to -Target $from -Force
}

Write-Output ".bashrc/ .bash_profile symbolic Link"
Add-Symlink "C:\Users\$env:UserName\.bashrc" "C:\Users\$env:UserName\dotfiles-windows\bash\.bashrc" > $null
Add-Symlink "C:\Users\$env:UserName\.bash_profile" "C:\Users\$env:UserName\dotfiles-windows\bash\.bash_profile" > $null

Write-Output "bash autocomplete..."
New-Item -Path C:\Users\$env:UserName\bash_completion.d -ItemType Directory -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" -OutFile "~/bash_completion.d/git"
Add-Content -Path C:\Users\$env:UserName\dotfiles-windows\bash\.bash_profile -Value 'source ~/bash_completion.d/git' -Force

Write-Output "Done"