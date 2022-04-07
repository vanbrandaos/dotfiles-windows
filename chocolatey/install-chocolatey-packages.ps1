#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force
#powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1


echo "Options:"
echo "1 - Package Utils"
echo "2 - List Package Utils"
echo "3 - Package WSL"
echo "4 - List Package WSL"
echo "5 - Package Dev"
echo "6 - List Package Dev"

$package = Read-Host ''Choose number''
$packageName = ""

if (1 -eq $package){
  echo " "
  echo "Installing Utils"
  $packageName = "./packages-utils.txt"
} elseif (2 -eq $package){
  echo " "
  echo "****Package Utils:"
  echo " "
  Get-Content "./packages-utils.txt" | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object{echo $_ }
  echo " "
  echo "****Package Utils****"
  echo " "
  powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1    
} elseif (3 -eq $package){
  echo " "
  echo "Installing WSL"
  $packageName = "./packages-wsl.txt"
} elseif (4 -eq $package){
  echo " "
  echo "****Package WSL****"  
  echo " "
  Get-Content "./packages-wsl.txt" | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object{echo $_ }
  echo " "
  echo "****Package WSL****"
  echo " "
  powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1
} elseif (5 -eq $package){
  echo " "
  echo "Installing Dev"
  $packageName = "./packages-dev.txt"
} elseif (6 -eq $package){
  echo " "
  echo "****Package Dev****"
  echo " "
  Get-Content "./packages-dev.txt" | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object{echo $_ }
  echo " "
  echo "****Package Dev****"
  echo " "
  powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1 
}else {
  echo "invalid option. Skiping..."
  exit
}

Get-Content $packageName | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object{choco install -y $_} 