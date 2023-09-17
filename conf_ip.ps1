Write-Host " ---------------------------- Configuration TCP/IP ----------------------------"


$networkAdapters = Get-NetAdapter 

Write-Host $networkAdapters

if ($networkAdapters.Count -eq 0) {
    Write-Host "Aucune carte réseau active n'a été trouvée."
    exit
}


Write-Host "Liste des cartes réseau disponibles :"
for ($i = 0; $i -lt $networkAdapters.Count; $i++) {
    Write-Host "$i : $($networkAdapters[$i].Name)"
}

$selection = Read-Host "Saisissez le numéro de la carte réseau que vous souhaitez configurer"

if ($selection -ge 0 -and $selection -lt $networkAdapters.Count) {
    $interface = $networkAdapters[$selection]
    
   
    $adresseIP = Read-Host "Saisissez l'adresse IP"
    $masque = Read-Host "Saisissez le masque de sous-réseau"
    $passerelle = Read-Host "Saisissez l'adresse de la passerelle"
    $DNSPrimaire = Read-Host "Saisissez l'adresse du serveur DNS primaire"
    $DNSSecondaire = Read-Host "Saisissez l'adresse du serveur DNS secondaire"
    
    $interface | Set-NetIPInterface -Dhcp Disabled
    $interface | New-NetIPAddress -IPAddress $adresseIP -PrefixLength 24 -DefaultGateway $passerelle
   
    $DNS = $interface | Get-DnsClientServerAddress
    $DNS | ForEach-Object {
        $_.ServerAddresses.Clear()
        $_.ServerAddresses.Add($DNSPrimaire)
        $_.ServerAddresses.Add($DNSSecondaire)
    }
   
    $interface | Select-Object -Property InterfaceAlias, InterfaceIndex, ifIndex, AddressFamily, AddressFamilySetting, Dhcp, ConnectionState, Status, IPEnabled, MediaType, Name, PhysicalMediaType, MacAddress | Format-Table -AutoSize
   
    Restart-NetAdapter -InterfaceAlias $interface.InterfaceAlias
} else {
    Write-Host "Sélection invalide. Le numéro de carte réseau n'est pas valide."
}
