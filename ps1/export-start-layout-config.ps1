Export-StartLayout -Path "C:\Users\$env:UserName\dotfiles-windows\start-layout\layout.json"

$Layout = Get-Content .\start-layout\layout.json -Raw | ConvertFrom-Json
$Layout.pinnedList | fl *