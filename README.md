
# Setup Windows

Those are my personal settings for my Windows' environments. Here I have a bit of PowerShell files for Windows, including common application installation through Chocolatey, and developer-minded Windows configuration defaults.

About PowerShell:

>PowerShell works with a scripts Execution Policy. By default this value is Restricted. 

**Run as Administrator*
**Set Execution Policy using:*
 - Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope currentUser
  (**Once you close, it will default back to the original execution policy*)
-  powershell -executionpolicy bypass -File .\install.ps1


1. Install [Chocolatey](https://chocolatey.org/install) (*run powershell as administrator*) 
```bash
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
2. Install git and update $PATH
```bash
    choco install git -y      
    $PathTemp = [Environment]::GetEnvironmentVariable('Path', 'User') + ';'
    $PathTemp += 'C:\Program Files\Git\bin'
    [Environment]::SetEnvironmentVariable('Path', $PathTemp, 'User')  
```
3. Ready to use git clone! 
```bash
    cd ~
    git clone https://github.com/vanbrandaos/.dotfiles.git
```
4. Install packages:
```bash
    cd dotfiles-windows/chocolatey
    powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1   
```
*Use choco like pacman! (choco install program | choco remove program | choco search program).*
*Yes! They have a GUI and you can install Chocolatey GUI via Chocolatey itself by executing:*
```bash
    choco install ChocolateyGUI
```

# Windows Terminal

1. Install Windows Terminal (option 5)
```bash
    cd dotfiles-windows/chocolatey
    powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1
```
2. Import settings.json (themes, shortcuts, profiles, etc) and install nerd-fonts
```bash
    cd dotfiles-windows/terminal
    powershell -executionpolicy bypass -File ./setup-windows-terminal.ps1
```

# Setup WSL2 :
**Run Windows Terminal as administrator and open PowerShell tab*

1. Copy .wslconfig file
```bash
    Copy-Item "C:\Users\$env:UserName\.dotfiles\dotfiles-windows\wsl\.wslconfig" -Destination "C:\Users\$env:UserName\"
```
2. Install WSL:
* Option 1: You must be running Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 
	```bash
	    wsl --install
	```
	*This option install Ubuntu. You can use 'wsl --install -d <Distribution Name>' to set another distro.*

* Option 2: If you just prefer a clean install
	- Enable WSL
		```bash
		    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart 
		```
	- Enable Virtual Machine
		```bash
		    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
		```
	- Restart Windows 
	- Download and install the [linux kernel](https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel)
	-  Set WSL2 as default version
		```bash
			wsl --set-default-version 2
		```


***Warnings***:

1. WSL does not have a init system. With Docker, you can use daemons like 'sudo dockerd' or install a alternative systemd (like [genie](https://github.com/arkane-systems/genie)). If you're using W11, see propertie "boot" in wsl.conf file. It's a good idea create a shell to wrap all startup operations.
	```bash
		[boot]
		command = sudo dockerd start
	```
	*This archive beloings under the path /etc/wsl.conf. If the file not there, you can create it yourself. WSL detect the existence of the file and will read its contents. All distributions use this file independently.*
2. IP address on WSL2 machine cannot be made static (If this is me being an idiot, I'm not the only one):

	- Custom domain:

		To accessing the WSL2 VM from the Windows host, see update-host.sh. This script, when called, updates your Windows hosts file with the WSL2 VM's IP address. Please change hostname.
		```bash
		    cd scripts/wsl
		    ./update-hosts.sh
		```
		On W10, I created an alias called 'wsl-update' that did this job (and started docker). If you are on W11, add this shell in the startup operations and avoid calling it every time when booting.

		*Find another solutions, like [Go-WSL2-Host](https://github.com/shayne/go-wsl2-host).*

	- Localhost:

			Turn off fast startup
			In WSL2, /etc/hosts lists 'localhost' as '127.0.0.1'
			In Windows (build 19041) 'localhost' resolves to ::1
			So the server in WSL was listening on 127.0.0.1 and the browser was trying to reach ::1

		**Microsoft already provides a solution to access your Linux services on Windows configuring [networking] tag on wsl.conf archive.* 
		**Other machines on your local network will not see the WSL network services unless you do some port forwarding (and firewall rules)*
3. Launch GUI applications: Only works in W11. For W10, try VcXsrv Windows X Server. 
  
# ArchWSL:

1. Download and install from [repository](https://github.com/yuk7/ArchWSL) (or use install-arch.ps1)
```bash
    cd dotfiles-windows/wsl
    powershell -executionpolicy bypass -File ./install-arch.ps1    
```
2. [Setup ArchWSL for user and keyrings](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/) 
3. Follow the [previous tutorial](https://github.com/vanbrandaos/.dotfiles)
4. Install find-the-command package and set fish as default shell
```bash
    cd scripts/wsl
    ./setup-fish.sh
```
