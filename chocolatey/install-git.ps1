#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force
#run in powershell: powershell -executionpolicy bypass -File .\install-chocolatey.ps1

if (!(Test-Path -Path "C:\Program Files\Git\bin")) {
  echo "Installing git"
  choco install git
  echo "git installed."

 echo "Updating PATH with C:\Program Files\Git\bin..."

#Path environment
$PathTemp = [Environment]::GetEnvironmentVariable('Path', 'User') + ';'

#Concat path for git.exe (%ProgramFiles%\Git\bin)
$PathTemp += 'C:\Program Files\Git\bin'

#Update path value with git
[Environment]::SetEnvironmentVariable('Path', $PathTemp, 'User')



echo "done!"

} else {
  echo "git is already installed."
}


