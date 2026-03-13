param (
    $Branch = 'Dev'
)
$br = git branch --show-current
if ($br -eq 'dev') {
    # Code généré par Gemini
    # 1. Définir le nom du module basé sur le nom du dossier actuel
    $ModuleName = 'CafeBlitz'
    $CurrentPath = Get-Location

    # 2. Déterminer le chemin de destination pour le scope 'CurrentUser'
    # On cible 'PowerShell' (Core/7+) ou 'WindowsPowerShell' (5.1) selon l'hôte
    $DocumentsPath = [Environment]::GetFolderPath('MyDocuments')
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $TargetFolder = Join-Path $DocumentsPath "PowerShell\Modules\$ModuleName"
    } else {
        $TargetFolder = Join-Path $DocumentsPath "WindowsPowerShell\Modules\$ModuleName"
    }

    Write-Host "Installation du module [$ModuleName] vers : $TargetFolder" -ForegroundColor Cyan

    # 3. Créer le dossier de destination s'il n'existe pas
    if (!(Test-Path $TargetFolder)) {
        New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
    }

    # 4. Copier les fichiers (en excluant le script d'installation lui-même et les dossiers Git)
    $ExcludeList = @("install.ps1", ".git*", ".vscode*")

    Copy-Item -Path "$CurrentPath\*" -Destination $TargetFolder -Recurse -Force -Exclude $ExcludeList

    Write-Host "Installation complétée avec succès !" -ForegroundColor Green
    Write-Host "Vous pouvez maintenant charger le module avec : Import-Module $ModuleName" -ForegroundColor Yellow
}