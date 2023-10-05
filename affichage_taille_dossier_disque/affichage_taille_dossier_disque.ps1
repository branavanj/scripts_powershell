
$entry = Read-Host "Entrez le chemin du dossier ou la lettre du lecteur (ex : C:\ ou D:\)"


if ($entry -ne "") {
    if (Test-Path $entry) {
        
        if (Test-Path -PathType Container $entry) {
            $folderSize = (Get-ChildItem $entry -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB
            Write-Host "La taille du dossier $entry est de $folderSize Go"
        }
        
        elseif (Test-Path -PathType Root $entry) {
            $driveInfo = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $entry }
            $freeSpace = $driveInfo.FreeSpace / 1GB
            $totalSize = $driveInfo.Size / 1GB
            Write-Host "L'espace libre sur le lecteur $entry est de $freeSpace Go sur un total de $totalSize Go"
        }
        else {
            Write-Host "L'entrée n'est ni un dossier ni un lecteur valide."
        }
    }
    else {
        Write-Host "Le chemin ou la lettre du lecteur spécifié n'existe pas."
    }
}
else {
    Write-Host "Aucune entrée n'a été saisie."
}
