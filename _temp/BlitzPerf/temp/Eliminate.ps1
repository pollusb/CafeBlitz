<#
.SYNOPSIS
    Script pour extraire les données ELININATE du fichier Excel généré par le Consultant ToolKit
.DESCRIPTION
    Produit le fichier SQL de la méthode DEATH à présenter au client.
.NOTES
    WISH: il faudra utiliser les fichiers clixml produit par mes scripts au lieu d'Excel
#>
param (
    $ExcelPath = 'C:\Users\pollbrod\Documents\SQLServerCheckup_query_outputs_SQ-PBDD22-BI_1_20210421_131729.xlsx',
    $WorkSheetName = 'Indexes M2',
    $StartRow = 5,
    $OutputScript = '.\Eliminate.sql',
    [switch]$Force
)
if (!$Force -and (Test-Path $OutputScript)) {
    throw "OutputScript exists. Use -Force to overwrite."
}
$tabIndexesM2 = Import-Excel -Path $ExcelPath -WorksheetName $WorkSheetName -StartRow $StartRow
# $tabUptime = Import-Excel -Path $ExcelPath -WorksheetName 'Uptime' -StartRow 7 -EndRow 8
$uptime = '33.33 days of uptime' #-f $tabUptime.'Days Uptime', $tabUptime.'Last Startup'

"/*
ExcelPath   $ExcelPath
D.E.A.T.H   ELIMINATE
Uptime      $uptime
Run date:   $(Get-Date -Format 'yyyy-MM-dd HH:mm')
*/" | Out-File $OutputScript

$filterNotPK   = {$_.'Index Name' -notmatch '^(PK|Unknown)'}

# Gets only rows with Index Usage that match: Reads = 0 and Write > 0
$filterUnused  = {$_.'Index Usage' -match 'Reads: 0.+Writes: [123456789]'}
$rowsFound     = $tabIndexesM2 | Where-Object $filterUnused | Where-Object $filterNotPK
$spaceReclamed = @()
foreach ($row in $rowsFound) {
"/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [$($row.'Database Name')]
Table       [$($row.'Schema Name')].[$($row.'Object Name')]
Index       [$($row.'Index Name')]
Rollback    $($row.'Create TSQL')
More Info   $($row.'More Info')
			$($row.'Index Usage')
			$($row.'Index Size')
            $uptime
*/
$($row.'Drop TSQL' -replace '^--', '')
" | Out-File -FilePath $OutputScript -Append
$spaceReclamed += ($row.'Index Size' -split('; '))[1]
}
$savedGB1 = (Invoke-Expression -Command ($spaceReclamed -join ' + ')) / 1GB
$count1 = $rowsFound.Count

# Gets only rows with Index Usage that match: Reads = 0 and Write > 0
$filterUnused  = {$_.'Index Usage' -match 'Reads: 0.+Writes: 0'}
$rowsFound     = $tabIndexesM2 | Where-Object $filterUnused | Where-Object $filterNotPK
$spaceReclamed = @()
foreach ($row in $rowsFound) {
"/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [$($row.'Database Name')]
Table       [$($row.'Schema Name')].[$($row.'Object Name')]
Index       [$($row.'Index Name')]
Rollback    $($row.'Create TSQL')
More Info   $($row.'More Info')
			$($row.'Index Usage')
			$($row.'Index Size')
            $uptime
*/
$($row.'Drop TSQL' -replace '^--', '')
" | Out-File -FilePath $OutputScript -Append
$spaceReclamed += ($row.'Index Size' -split('; '))[1]
}
$savedGB2 = (Invoke-Expression -Command ($spaceReclamed -join ' + ')) / 1GB
$count2 = $rowsFound.Count

"/*
SOMMAIRE
{0} indexes sont considérés nuisibles. Les supprimer, libèrera {1:n2} GB
{2} indexes sont considérés inutiles. Les supprimer, libèrera {3:n2} GB
*/" -f $count1, $savedGB1, $count2, $savedGB2 | Tee-Object -FilePath $OutputScript -Append
