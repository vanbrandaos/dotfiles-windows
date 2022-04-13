



# Setup Windows

Those are my personal settings for my Windows' environments. Here I have a bit of PowerShell files for Windows, including common application installation through Chocolatey, and developer-minded Windows configuration defaults.

# Desired Features:

- Scoop and Chocolatey
- Packages list (wsl, dev, utils) installed via chocolatey
- Windows Terminal (custom settings.json)
- Git (SSH keys and aliases)
- Code (and Java/JavaScript extensions)
- WSL (using ArchWSL)

# :warning: Using PowerShell:

PowerShell scripts are easy to use but there are a couple of things to be aware of, especially when it is the first time you use such scripts. 

>The PowerShell Execution Policy determines whether PowerShell scripts are allowed to run. By default, the Execution Policy is set to Restricted.

**To change the execution policy (on powershell terminal):*
 1. Use 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope currentUser' before executing your scripts (**Once you close, it will default back to the original execution policy*)
 2. Use 'powershell -executionpolicy bypass -File .\install.ps1' using execution policy as parameter to run all scripts 

**To execute any command to change execution policy, you must have administrator permission, open PowerShell command prompt with Run as administrator**

See Microsoft's Docs [About Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2) for detailed information.


# Initial Settings

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
    cd chocolatey
    powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1   
```
*Use choco like pacman/apt get using these [commands](https://docs.chocolatey.org/en-us/choco/commands/)!* <br />
*Yes! They have a GUI and you can install Chocolatey GUI via Chocolatey itself by executing:*
```bash
    choco install ChocolateyGUI
```

# Windows Terminal

1. If you didn't install it, install Windows Terminal (option 5) or skip
```bash
    cd chocolatey
    powershell -executionpolicy bypass -File .\install-chocolatey-packages.ps1
```
2. Import settings.json (themes, shortcuts profiles, etc), starship and install nerd-fonts
```bash
    cd terminal
    powershell -executionpolicy bypass -File ./setup-windows-terminal.ps1
```
*Note: The custom settings bring up profiles that may not exist, such as WSL Arch (see below). You may need to change Terminal Profiles later. *

# Git (and Git Bash)

1. Create a new SSH key
```bash
    cd git
    powershell -executionpolicy bypass -File .\configure-ssh.ps1
```
2. Import .bash files (Bash with Windows Terminal)
```bash
    cd git
    powershell -executionpolicy bypass -File .\setup-bash.ps1
```
3. Replace 'ls' command (LSDeluxe):
	


	3.1  ~~First, the best way to install lsd was using 'scoop install lsd', but at moment (April 2022) scoop install 0.21.0 and Git bash cant handle the 256 color scheme thats introduced in lsd version 0.21. We need [download and install](https://github.com/Peltoche/lsd/releases) lsd 0.20, extract and update $PATH with new lsd path (suggestion: ~/lsd). Open ~/.bashrc and update ls alias (lsd -la)~~. Create a 

	3.2. Yes, i can do it:
```bash
     cd git
     powershell -executionpolicy bypass -F ./install-lsd.ps1
```


# Code

1. Install extensions
```bash
    cd vscode
    powershell -executionpolicy bypass -File .\install-extensions.ps1
    powershell -executionpolicy bypass -File .\install-java-extensions.ps1
```

# Setup WSL2 :

1. Copy .wslconfig file
```bash
    Copy-Item "C:\Users\$env:UserName\dotfiles-windows\wsl\.wslconfig" -Destination "C:\Users\$env:UserName\"
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

		 access the WSL2 VM from the Windows host, see update-host.sh (this shell belongs a [.dotfiles](https://github.com/vanbrandaos/.dotfiles) for linux). This script, when called, updates your Windows hosts file with the WSL2 VM's IP address. Please change hostname.
		```bash
		cd scripts/wsl
		./update-hosts.sh
		```
		On W10, I created an alias called 'wsl-update' that did this job (and started docker). If you are on W11, add this shell in the startup operations and avoid calling it every time when booting.

		*Find another solutions, like [Go-WSL2-Host](https://github.com/shayne/go-wsl2-host).*

	- Localhost:
		```
		Turn off fast startup
		In WSL2, /etc/hosts lists 'localhost' as '127.0.0.1'
		In Windows (build 19041) 'localhost' resolves to ::1
		So the server in WSL was listening on 127.0.0.1 and the browser was trying to reach ::1
		```

		**Microsoft already provides a solution to access your Linux services on Windows configuring [networking] tag on wsl.conf archive.* 
		**Other machines on your local network will not see the WSL network services unless you do some port forwarding (and firewall rules)*
3. Launch GUI applications: Only works in W11. For W10, try [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/). 
  
# WSL Distro: ArchWSL

**If you prefer, search in Microsoft Store for other distros*

1. Download and install from [github](https://github.com/yuk7/ArchWSL) (or use install-arch.ps1)
```bash
    cd wsl
    powershell -executionpolicy bypass -File ./install-arch.ps1    
```
2. [Setup ArchWSL for user and keyrings](https://wsldl-pg.github.io/ArchW-docs/How-to-Setup/) 
3. See Arch [.dotfiles](https://github.com/vanbrandaos/.dotfiles)
4. Install find-the-command and set fish as default shell (This sh belongs a [.dotfiles](https://github.com/vanbrandaos/.dotfiles))
```bash
    cd scripts/wsl
    ./setup-fish.sh
```
