<#
.SYNOPSIS
    Script pour extraire les données ELININATE du fichier Excel généré par le Consultant ToolKit
.DESCRIPTION
    Produit le fichier SQL de la méthode DEATH à présenter au client.
.NOTES
    WISH: il faudra utiliser les fichiers clixml produit par mes scripts au lieu d'Excel
#>
function ForwardedFetches {
    param (
        $ExcelPath,
        $WorkSheetName,
        $StartRow = 1,
        $OutputScript = '.\RebuildTables.sql',
        $Filter  = {$_.'Forwarded Fetches' -gt 0}, # fonctionne bien maintenant
        $Sort = {$_.'Database Name',$_.'Schema Name',$_.'Object Name'},
        [switch]$OutputObject,
        [switch]$Force
    )
    if (!$Force -and (Test-Path $OutputScript)) {
        throw "OutputScript exists. Use -Force to overwrite."
    }
    $indexData = Import-Excel -Path $ExcelPath -WorksheetName $WorkSheetName -StartRow $StartRow
    $rowsFound = $indexData | Where-Object {$_.'Index ID' -eq 0} | Where-Object $Filter | Sort-Object $Sort

    if ($OutputObject) {
        return $rowsFound
    }

    "/*
    ExcelPath   $ExcelPath
    Run date:   $(Get-Date -Format 'yyyy-MM-dd HH:mm')
    */" | Out-File $OutputScript

    foreach ($row in $rowsFound) {
        $ratio = $row.'Forwarded Fetches' / $row.Rows
"/*
Database    [$($row.'Database Name')]
Table       [$($row.'Schema Name')].[$($row.'Object Name')]
FF          $($row.'Forwarded Fetches') (ff/rows: $ratio)
More Info   $($row.'More Info')
            $($row.'Index Usage')
            $($row.'Index Size')
*/
ALTER TABLE [$($row.'Database Name')].[$($row.'Schema Name')].[$($row.'Object Name')] REBUILD;
PRINT 'REBUILD [$($row.'Database Name')].[$($row.'Schema Name')].[$($row.'Object Name')] Terminé';
GO
" | Out-File -FilePath $OutputScript -Append
    }
    $count1 = $rowsFound.Count

"/*
SOMMAIRE
{0} tables identifiées à reconstruire
*/" -f $count1 | Tee-Object -FilePath $OutputScript -Append

}
