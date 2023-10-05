$newComputerName = Read-Host "Entrez le nouveau nom de l'ordinateur"

if ($newComputerName -ne "") {
   
    Rename-Computer -NewName $newComputerName -Force -Restart
} else {
    Write-Host "Aucun nom n'a été saisi. L'ordinateur ne sera pas renommÃ©."
}
