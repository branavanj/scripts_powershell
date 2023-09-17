Write-Host " ---------------------------- Configuration TCP/IP ----------------------------"

# Liste des cartes réseau disponibles
$networkAdapters = Get-NetAdapter 

Write-Host $networkAdapters

if ($networkAdapters.Count -eq 0) {
    Write-Host "Aucune carte réseau active n'a été trouvée."
    exit
}

# Afficher la liste des cartes réseau et leurs indices
Write-Host "Liste des cartes réseau disponibles :"
for ($i = 0; $i -lt $networkAdapters.Count; $i++) {
    Write-Host "$i : $($networkAdapters[$i].Name)"
}

# Demander à l'utilisateur de saisir le numéro de la carte réseau à configurer
$selection = Read-Host "Saisissez le numéro de la carte réseau que vous souhaitez configurer"

if ($selection -ge 0 -and $selection -lt $networkAdapters.Count) {
    $interface = $networkAdapters[$selection]
    
    # Demander à l'utilisateur de saisir les nouvelles valeurs IP statiques
    $adresseIP = Read-Host "Saisissez l'adresse IP"
    $masque = Read-Host "Saisissez le masque de sous-réseau"
    $passerelle = Read-Host "Saisissez l'adresse de la passerelle"
    $DNSPrimaire = Read-Host "Saisissez l'adresse du serveur DNS primaire"
    $DNSSecondaire = Read-Host "Saisissez l'adresse du serveur DNS secondaire"
    
    # Définir les nouvelles propriétés IP pour l'interface sélectionnée
    $interface | Set-NetIPInterface -Dhcp Disabled
    $interface | New-NetIPAddress -IPAddress $adresseIP -PrefixLength 24 -DefaultGateway $passerelle
    
    # Définir les serveurs DNS
    $DNS = $interface | Get-DnsClientServerAddress
    $DNS | ForEach-Object {
        $_.ServerAddresses.Clear()
        $_.ServerAddresses.Add($DNSPrimaire)
        $_.ServerAddresses.Add($DNSSecondaire)
    }
    
    # Afficher les nouvelles configurations IP
    $interface | Select-Object -Property InterfaceAlias, InterfaceIndex, ifIndex, AddressFamily, AddressFamilySetting, Dhcp, ConnectionState, Status, IPEnabled, MediaType, Name, PhysicalMediaType, MacAddress | Format-Table -AutoSize
    
    # Redémarrer l'interface pour appliquer les changements
    Restart-NetAdapter -InterfaceAlias $interface.InterfaceAlias
} else {
    Write-Host "Sélection invalide. Le numéro de carte réseau n'est pas valide."
}