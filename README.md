



# Setup Windows

Those are my personal settings for Windows' environments. Here I have a bit of PowerShell files, including common application installation through Chocolatey, and developer-minded Windows configuration defaults.

Usually as Linux host (with WSL), on Windows I just keep initial configs, that includes Git (Bash), Java e some IDE's. 

# Desired Features:

- Custom Windows Start Menu
- Scoop and Chocolatey (package manager)
- Packages list (wsl, dev, utils) installed via chocolatey
- Windows Terminal (custom settings.json) + Starship + NerdFonts
- Git - SSH keys and Bash aliases (on Windows)
- Code (and Java/JavaScript extensions)
- WSL setup and ArchWSL (distro)

# :warning: Using PowerShell:

PowerShell scripts are easy to use but there are a couple of things to be aware of, especially when it is the first time you use such scripts. 

>The PowerShell Execution Policy determines whether PowerShell scripts are allowed to run. By default, the Execution Policy is set to Restricted.

**To change the execution policy (on powershell terminal):*
 1. 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope currentUser' before executing your scripts (**Once you close, it will default back to the original execution policy*)
 2. 'powershell -executionpolicy bypass -File .\install.ps1' using execution policy as parameter to run all scripts 

**To execute any command to change execution policy, you must have administrator permission, open PowerShell command prompt with Run as administrator**

See Microsoft's Docs [About Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2) for detailed information.

# Start Menu

To export, use export-config.ps1 and create a StartMenuLayout.xml.
```bash
    powershell -executionpolicy bypass -File .\ps1\export-start-layout-config.ps1
```
To import, open gpedit.msc (Menu > Run) and set a path on User Configuration > Administrative Template > Start Menu and Taskbar

**Need active Group Policy Editor. On Windows Home, this funcionability has inactive by default.* 

# Initial Settings (Pre-Requirements)

1. Install [Scoop](https://scoop.sh/) (**Running the scoop installer as administrator is disabled by default, run powershell with user privileges**)
```bash
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
```
*Read [Scoop Wiki](https://github.com/ScoopInstaller/Scoop/wiki)*

2. Close PowerShell and reopen as Administrator

3. Install [Chocolatey](https://chocolatey.org/install) 
```bash
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
*NOTE: Windows 11 comes with WinGet by default which makes it officially Microsoft's open source package manager going forward.*
*Right now using Chocolatey is better as it has more packages and is just easier to use. Scoop is especially focused on the handling of development environment building software such as programmers. Also, WinGet is not a package manager in the traditional sense as it only installs software in the formats - MSI, MSIX and some EXE.*


4. Install git and update $PATH
```bash
    choco install git -y      
    $PathTemp = [Environment]::GetEnvironmentVariable('Path', 'User') + ';'
    $PathTemp += 'C:\Program Files\Git\bin'
    [Environment]::SetEnvironmentVariable('Path', $PathTemp, 'User')  
```
5. Ready to use git clone!
```bash
    cd ~
    git clone https://github.com/vanbrandaos/dotfiles-windows.git
```
6. Install packages:
```bash
    powershell -executionpolicy bypass -File .\ps1\install-chocolatey-packages.ps1
```
*Use choco like pacman/apt get using these [commands](https://docs.chocolatey.org/en-us/choco/commands/)!* <br />
*Yes! They have a GUI and you can install Chocolatey GUI via Chocolatey itself by executing:*
```bash
    choco install ChocolateyGUI
```

# Windows Terminal

1. If you didn't install it, install Windows Terminal (option 3) or skip
```bash
    powershell -executionpolicy bypass -File .\ps1\install-chocolatey-packages.ps1
```
2. Import settings.json (themes, shortcuts profiles, etc), starship and install nerd-fonts
```bash
    powershell -executionpolicy bypass -File .\ps1\setup-windows-terminal.ps1
```

*Note: The custom settings bring up profiles that may not exist, such as WSL Arch (see below). You may need to change Terminal Profiles later. *
*Note: To install only Windows Terminal, run **choco install microsoft-windows-terminal** on PowerShell*

# Git (and Git Bash)
Settings on/for Windows. Skip if you don't want keep your ssh key here, neither aliases for Bash and simulations for ls command.


1. Create a new SSH key and symbolic links
```bash
    powershell -executionpolicy bypass -File .\ps1\create-and-configure-ssh.ps1
```
**OR**

- Import your SSH (and symbolic links): Needed paste your public and private key to /git.
```bash
    powershell -executionpolicy bypass -File .\ps1\import-and-configure-ssh.ps1
```

2. Import .bash files (Bash with Windows Terminal)
```bash
    powershell -executionpolicy bypass -File .\ps1\setup-bash.ps1
```
3. Replace 'ls' command ([LSDeluxe](https://github.com/Peltoche/lsd#installation)):

	3.1  ~~First, the best way to install lsd was using 'scoop install lsd', but at moment (April 2022) scoop install 0.21.0 and Git bash cant handle the 256 color scheme thats introduced in lsd version 0.21. We need [download and install](https://github.com/Peltoche/lsd/releases) lsd 0.20, extract and update $PATH with new lsd path (suggestion: ~/lsd). Open ~/.bashrc and update ls alias (lsd -la)~~. *Bug on 0.21.

	3.2. Yes, i can do it:
```bash
    powershell -executionpolicy bypass -File .\ps1\install-lsd.ps1
```
**Need some Nerd font. The 'Fantasque Sans Mono' font was installed (step 2 - Windows Terminal). Skip if you've already done this or [download and install](https://www.nerdfonts.com/) your favorite.*

EXA is coming!
>Very soon now. It is looking highly likely that the current version of exa (v0.10.0) will be the last without Windows support.

# Code

1. Install extensions
```bash
    powershell -executionpolicy bypass -File .\ps1\install-extensions.ps1
    powershell -executionpolicy bypass -File .\ps1\install-java-extensions.ps1
```

# Setup WSL2 :

1. Copy .wslconfig file
```bash
    Copy-Item "C:\Users\$env:UserName\dotfiles-windows\wsl\.wslconfig" -Destination "C:\Users\$env:UserName\"
```
*[Advanced settings configuration in WSL](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig)*

2. Install WSL:
* Option 1: You must be running Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 
	```bash
	    wsl --install
	```
	*This option install Ubuntu. You can use 'wsl --install -d <Distribution Name>' to set another distro.*

* Option 2: If you just prefer a clean install (also for older versions of WSL)
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

1. IP address on WSL2 machine cannot be made static (If this is me being an idiot, I'm not the only one):

	- Custom domain:

		 access the WSL2 VM from the Windows host, see update-host.sh (this shell belongs a [.dotfiles](https://github.com/vanbrandaos/.dotfiles) for linux). This script, when called, updates your Windows hosts file with the WSL2 VM's IP address. Please change hostname.
		```bash
		cd scripts/wsl
		./update-hosts.sh
		```
		If you are on W11, add this shell in the startup operations and avoid calling it every time when booting.

		*Find another solutions, like [Go-WSL2-Host](https://github.com/shayne/go-wsl2-host).*

2. Launch GUI applications: For W10, try [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/). 
  
# WSL Distro: ArchWSL

**If you prefer, search in Microsoft Store for other distros*

1. Download and install from [github](https://github.com/yuk7/ArchWSL) (or use install-arch.ps1)
```bash
    powershell -executionpolicy bypass -File .\ps1\install-arch.ps1
```
2. Reset Terminal, go to Arch folder (C:/wsl/Arch) and [Setup ArchWSL for user and keyrings](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/) 
3. See Arch [.dotfiles](https://github.com/vanbrandaos/.dotfiles) (only Arch distros)
#	
![windows terminal](terminal/img/screenshot.png)
