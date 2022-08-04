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

$keyname = Read-Host "Please enter your keyname"
$comment = $keyname

if (!(Test-Path -Path "C:\Users\$env:UserName\dotfiles-windows\git\$keyname")) {
    Write-Output "Private key $keyname not found. Paste your private key on current folder: /git"
    Write-Output 'Nothing to do. Exiting...'
    Exit
}


if (!(Test-Path -Path "C:\Users\$env:UserName\dotfiles-windows\git\$keyname.pub")) {
    Write-Output "Public key $keyname not found. Paste your public key on current folder: /git"
    Write-Output 'Nothing to do. Exiting...'
    Exit
}

New-Item -Path 'config' -ItemType File -Force
Set-Content config "Host github.com
    HostName github.com
    IdentityFile ~/.ssh/$path$keyname"


if (!(Test-Path -Path "C:\Users\$env:UserName\.ssh")) {
    New-Item -Path C:\Users\$env:UserName\.ssh -ItemType Directory -Force
}

Write-Output "Replacing .gitconfig"
Add-Symlink "C:\Users\$env:UserName\.gitconfig" "C:\Users\$env:UserName\dotfiles-windows\git\.gitconfig" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\$keyname" "C:\Users\$env:UserName\dotfiles-windows\git\$keyname" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\$keyname.pub" "C:\Users\$env:UserName\dotfiles-windows\git\$keyname.pub" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\config" "C:\Users\$env:UserName\dotfiles-windows\git\config" > $null
Write-Output "Done"

echo "KEY IMPORTED DO NOT FORGET TO UPLOAD THE PUBLIC PART!!!"