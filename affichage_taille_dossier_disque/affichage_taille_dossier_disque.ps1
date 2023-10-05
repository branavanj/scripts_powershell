# Demande � l'utilisateur de saisir le chemin du dossier ou la lettre du lecteur
$entry = Read-Host "Entrez le chemin du dossier ou la lettre du lecteur (ex : C:\ ou D:\)"

# V�rifie si une entr�e a �t� saisie
if ($entry -ne "") {
    if (Test-Path $entry) {
        # Si l'entr�e est un chemin de dossier valide
        if (Test-Path -PathType Container $entry) {
            $folderSize = (Get-ChildItem $entry -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB
            Write-Host "La taille du dossier $entry est de $folderSize Go"
        }
        # Si l'entr�e est une lettre de lecteur valide
        elseif (Test-Path -PathType Root $entry) {
            $driveInfo = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $entry }
            $freeSpace = $driveInfo.FreeSpace / 1GB
            $totalSize = $driveInfo.Size / 1GB
            Write-Host "L'espace libre sur le lecteur $entry est de $freeSpace Go sur un total de $totalSize Go"
        }
        else {
            Write-Host "L'entr�e n'est ni un dossier ni un lecteur valide."
        }
    }
    else {
        Write-Host "Le chemin ou la lettre du lecteur sp�cifi� n'existe pas."
    }
}
else {
    Write-Host "Aucune entr�e n'a �t� saisie."
}
