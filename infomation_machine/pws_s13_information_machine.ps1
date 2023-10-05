<#
-----------------------------------------------------------------------
NOM : pws_s13_information_machine.ps1
AUTEUR : Branavan JEYAKUMAR
DATE : 16/09/2022
VERSION : 1.0
COMMENTS : renomme une machine
PowerShell : Version 5.1 ($PSVersionTable)
Autorisation exécution script local : Set-ExecutionPolicy RemoteSigned
-----------------------------------------------------------------------
#>


Clear-Host
Write-Host "-------------------------INFORMATION Machine --------------------- "

$hostname = hostname  
Write-Host " nom machine :" $hostname

$IP = Get-NetIPAddress -InterfaceIndex 12 -AddressFamily IPv4 | Select-Object -ExpandProperty IPaddress 
Write-Host " Adresse IP : " $IP

$masque = "/{0}" -f (Get-NetIPAddress -InterfaceAlias Ethernet2 -AddressFamily IPv4 | Select-Object -ExpandProperty PrefixLength)
Write-Host " Masque : " $masque

$passerelle = Get-NetIPConfiguration  | Select-Object -ExpandProperty IPv4DefaultGateway | Select-Object -ExpandProperty NextHop
Write-Host " Passerelle : " $passerelle

$Dns = Get-NetIPConfiguration | Select-Object -ExpandProperty DNSServer | Select-Object -ExpandProperty ServerAddresses
Write-Host " DNS : " $Dns

$domaine =  Get-NetIPConfiguration  | Select-Object -ExpandProperty NetProfile | Select-Object -ExpandProperty Name
Write-Host " Domaine : " $domaine

$ram = Get-CimInstance CIM_ComputerSystem
$ram2 = "{0:N2}" -f ($ram.TotalPhysicalMemory/1GB)
Write " Memoire ram :"$ram2"GB"

$cpu = Get-CimInstance CIM_Processor | Select-Object -ExpandProperty Name
Write-Host " Cpu : " $cpu


$user = Get-CimInstance CIM_OperatingSystem | Select-Object -ExpandProperty RegisteredUser
Write-Host " Utilisateur actuellement connecte :" $user

$os = Get-ComputerInfo | Select-Object -ExpandProperty OsName
Write-Host " Systeme d'Exploitation :" $os

$diskuse = Get-PSDrive C
$diskuse1 = "{0:N2}" -f ($diskuse.Used/1GB)
Write-Host " Espace Utilise dans le disque C : " $diskuse1"Go"

$diskfree = Get-PSDrive C
$diskfree1 = "{0:N2}" -f ($diskfree.Free/1GB)
Write-Host " Espace Libre dans le disque C : " $diskfree1"Go"


