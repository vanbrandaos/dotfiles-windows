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


if (!(Test-Path -Path "C:\Users\$env:UserName\lsd")) {
    New-Item -Path "C:\Users\$env:UserName\lsd" -ItemType Directory -Force    
    Set-Location -Path "C:\Users\$env:UserName\lsd"
}

$default_url = "https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-i686-pc-windows-gnu.zip"
echo "Download LSD ZIP from: $default_url"
$url = Read-Host ''Paste a new ZIP URL or confirm URL pressing enter''
if ("" -eq $url){
    $url = $default_url
}

echo "Extracting LSD $url..."   
Invoke-WebRequest -Uri $url -OutFile "C:\Users\$env:UserName\lsd\lsd.zip"
Expand-Archive "C:\Users\$env:UserName\lsd\lsd.zip" -DestinationPath "C:\Users\$env:UserName\lsd"
Remove-Item "C:\Users\$env:UserName\lsd\lsd.zip"

$LSDPath = Get-ChildItem -Path "C:\Users\$env:UserName\lsd" -Recurse -Depth 1
    foreach ($archive in $LSDPath) {
        $Parent_Directory = Split-Path -Path $archive.FullName -Parent
        $name = Split-Path -Path $archive.FullName -Leaf

        if (!("C:\Users\$env:UserName\lsd" -eq $Parent_Directory)) {
                Move-Item -Path "$Parent_Directory\$name" -Destination "C:\Users\$env:UserName\lsd"
        }
    }

echo "Updating PATH..."
$PathTemp = [Environment]::GetEnvironmentVariable('Path', 'User') + ';'
$PathTemp += "C:\Users\$env:UserName\lsd"
[Environment]::SetEnvironmentVariable('Path', $PathTemp, 'User')

echo "Updating ~/.bashrc alias for ls..."
$newLS = "lsd -la --blocks permission --blocks size --blocks user --blocks date --date '+%d %b %y %X' --blocks name"
#$bashrc = (Get-Content -path "C:\Users\$env:UserName\dotfiles-windows\git\.bashrc" -Raw) -replace 'ls -al --color=auto',"lsd -la --blocks permission --blocks size --blocks user --blocks date --date '+%d %b %y %X' --blocks name" | Set-Content -Path "C:\Users\$env:UserName\dotfiles-windows\git\.bashrc"

$bashrc = (Get-Content -path "C:\Users\$env:UserName\dotfiles-windows\bash\.bashrc" -Raw) -replace 'ls -al --color=auto', $newLS | Set-Content -Path "C:\Users\$env:UserName\dotfiles-windows\bash\.bashrc"

#echo "Symlink for ~/.config/lsd/config.yaml"
#Add-Symlink "C:\Users\$env:UserName\.config\lsd\config.yaml" "C:\Users\$env:UserName\dotfiles-windows\git\config.yaml" > $null

echo "DONE! Restart terminal and use ls command"


