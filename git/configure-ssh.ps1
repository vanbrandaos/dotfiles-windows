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
ssh-keygen -t ed25519 -C "vanbrandaos@gmail.com" -f $keyname

#Remove-Item 'config'
New-Item -Path 'config' -ItemType File -Force
Set-Content config "Host github.com
    HostName github.com
    IdentityFile ~/.ssh/$path$keyname"


if (!(Test-Path -Path "C:\Users\$env:UserName\.ssh")) {
    New-Item -Path C:\Users\$env:UserName\.ssh -ItemType Directory -Force
}

Write-Output "Replacing .gitconfig"
Add-Symlink "C:\Users\$env:UserName\.gitconfig" "C:\Users\$env:UserName\dotfiles-windows\bootstrap\.gitconfig" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\$keyname" "C:\Users\$env:UserName\dotfiles-windows\bootstrap\$keyname" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\$keyname.pub" "C:\Users\$env:UserName\dotfiles-windows\bootstrap\$keyname.pub" > $null
Add-Symlink "C:\Users\$env:UserName\.ssh\config" "C:\Users\$env:UserName\dotfiles-windows\bootstrap\config" > $null
Write-Output "Done"

echo "KEY CREATED DO NOT FORGET TO UPLOAD THE PUBLIC PART!!!"