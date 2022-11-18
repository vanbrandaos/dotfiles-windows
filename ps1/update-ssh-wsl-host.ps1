echo 'Trying create a SSH fowarding port for WSL ...' 

#$remoteip = bash.exe -c "ip addr show eth0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1 "
$remoteip = bash.exe -c "ip addr show eth0 | grep 'inet\b' | cut -d/ -f1 | sed 's/inet//g'"

echo $remoteip

$port='2222';

$addr='0.0.0.0';


Get-NetFirewallRule -DisplayName "Open Port 2222 for WSL2" | Remove-NetFireWallRule
#Remove-NetFirewallRule -DisplayName "Open Port 2222 for WSL2"
New-NetFirewallRule -DisplayName "Open Port 2222 for WSL2" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port 
#New-NetFireWallRule -DisplayName 'Open Port 2222 for WSL2'  -Direction Outbound -LocalPort $port -Action Allow -Protocol TCP\


iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr\";
iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteip";