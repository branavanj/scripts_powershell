Install-WindowsFeature -Name OpenSSH-Server -IncludeManagementTools

Start-Service sshd

Set-Service -Name sshd -StartupType 'Automatic'

$changePort = Read-Host "Voulez-vous changer le port SSH ? (O/N)"

if ($changePort -eq "O" -or $changePort -eq "o") {
   
    $newPort = Read-Host "Entrez le nouveau port SSH"

    if ($newPort -match '^\d+$') {
        
        Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH\DefaultShell" -Name "SSH-Port" -Value $newPort
        Write-Host "Le port SSH a été configuré sur le port $newPort."
    } else {
        Write-Host "Le port SSH n'a pas été configuré car une valeur non valide a été saisie."
    }
}


Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH\DefaultShell" -Name "Subsystems" -Value "sftp;C:\Windows\System32\OpenSSH\sftp-server.exe"

Restart-Service sshd

$sshServiceStatus = Get-Service sshd
Write-Host "Le service OpenSSH est maintenant configuré et en cours d'exécution."
Write-Host "Statut du service OpenSSH : $($sshServiceStatus.Status)"
