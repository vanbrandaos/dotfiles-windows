echo '### Baixando Arch...'

if (!(Test-Path -Path "C:\wsl\Arch")) {
    Set-Location -Path C:\
    md wsl/Arch
    #Set-Location -Path "C:\wsl\fonts"        
}

$default_url = "https://github.com/yuk7/ArchWSL/releases/download/22.3.18.0/Arch.zip"
echo "Download Arch ZIP from: $default_url"
$url = Read-Host ''Paste a new ZIP URL or confirm URL pressing enter''
if ("" -eq $url){
    $url = $default_url
}

echo "Extracting Arch $url..."    
Invoke-WebRequest -Uri $url -OutFile "C:\wsl\Arch\Arch.zip"        
Expand-Archive "C:\wsl\Arch\Arch.zip" -DestinationPath "C:\wsl\Arch\"
Remove-Item "C:\wsl\Arch\Arch.zip"
#start "C:\wsl\Arch"
Start-Process -NoNewWindow -FilePath  "C:\wsl\Arch\Arch.exe"

#echo '### Concluído'
