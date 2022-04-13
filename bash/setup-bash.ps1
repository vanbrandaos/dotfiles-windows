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
Write-Output "Done"