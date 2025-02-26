function Invoke-BlitzCache {
    <#
    .SYNOPSIS
    Pour générer des fichiers de type .blitz.cache.xml

    .PARAMETER Path
    Les fichiers seront organisés dans des dossier à partir de ce point de la façon suivante:
    $Path\Machine\Instance\Cache\$SortOrder

    .PARAMETER Database
    Il est possible de filtrer pour 1 seule BD sinon, les plans de toute les BD seront exportés

    .NOTES
    https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/blob/dev/sp_BlitzCache.sql
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        [string]$Database, # All user databases by default, else only one database is permitted

        [ValidateSet('cpu','reads','writes','duration','executions','recent compilation','memory grant','unused grant','spills','xpm')]
        $SortOrder = 'cpu',

        $Path = "$home\Code\Temp" # $Path\Machine\Instance\Cache\$SortOrder
    )
    if ($SqlInstance -gt 1) { Write-Verbose "Number of SQL Instances = $($SqlInstance.Count)" }
    foreach ($sql in $SqlInstance) {
        if ($Database) {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzCache @DatabaseName='$Database', @SortOrder='$SortOrder', @ExpertMode=1;"
        } else {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzCache @AllDatabases=1, @SortOrder='$SortOrder', @ExpertMode=1;"
        }
        Write-Verbose $query

        $result = Invoke-DbaQuery -SqlInstance $sql -Query $query -As DataSet
        if ($Result) {
            # Exporter les plans sur le disque
            $position = 0
            mkdir "$Path\$($sql.ToUpper())\Cache\$SortOrder" -ea SilentlyContinue | Select-Object Fullname | Out-Verbose
            $ofDatabase = if ($Database) {"_of_$Database"}
            foreach ($line in $result.Tables[0]) {
                $filePlan = '{0}\{1}\Cache\{2}\Top{3}{4}.sqlplan' -f $Path, $sql, $SortOrder, (++$position), $ofDatabase
                Write-Verbose $filePlan
                $line | Select-Object -ExpandProperty 'Query Plan' | Out-File $filePlan -Encoding utf8 -Force
            }
            $fileClixml = '{0}\{1}\Cache\Top10.{2}{3}.blitz.cache.xml' -f $Path, $sql, $SortOrder, $ofDatabase
            Write-Verbose $fileClixml
            $result | Export-Clixml -Path $fileClixml
        } else {
            Write-Warning "No plan found for $sql"
        }
    }
}

function Format-BlitzCache {
    <#
    .SYNOPSIS
    Pour lire les fichiers de type .blitz.cache.xml
    Montrer le contenu du fichier avec des modifs suivantes:
    - retrait des colonnes ou il n'y a pas d'info ou la valeur est XML
    - retrait de la première ligne
    - renommer les colonnes pour faciliter l'exportation vers Excel ou SQL
    - Présenter les informations selon différents templates
    #>
    [CmdletBinding()]
    param (
        $Path = 'C:\Users\dba-pollbrod\Code\Temp\RcpdStagingDTCC1A.dbo.StagingBusinessVault.xml',
        $Template = 'Simple'
    )
    $DefaultPathClixml = 'C:\Users\dba-pollbrod\Code\Temp'
    if (!Test-Path $Path) {
        $Path = "$DefaultPathClixml\$Path"
        if (!Test-Path $Path) { throw "$Path not found." }
    }
    Write-Verbose $Path

    #region définition des colonnes

    $cliXml = import-clixml $Path
    $col1 =  @{n='Details';  e={$_.'Details: db_schema.table.index(indexid)'}}
    $col2 =  @{n='Definition';  e={$_.'Definition: [Property] ColumnName {datatype maxbytes}'}}
    $col3 =  @{n='SecretCol';  e={$_.'Secret Columns'}}
    $col4 =  @{n='Fillfactor';  e={$_.'Fillfactor'}}
    $col5 =  @{n='UsageStat';  e={$_.'Usage Stats'}}
    $col6 =  @{n='OpStats';  e={$_.'Op Stats'}}
    $col7 =  @{n='Size';  e={$_.'Size'}}
    $col8 =  @{n='Compress';  e={$_.'Compression Type'}}
    $col9 =  @{n='LockW';  e={$_.'Lock Waits'}}
    $col10 = @{n='RefByFK'; e={$_.'Referenced by FK?'}}
    $col11 = @{n='FKCovered'; e={$_.'FK Covered by Index?'}}
    $col12 = @{n='LastUserSeek'; e={$_.'Last User Seek'}}
    $col13 = @{n='LastUserScan'; e={$_.'Last User Scan'}}
    $col14 = @{n='LastUserLookup'; e={$_.'Last User Lookup'}}
    $col15 = @{n='LastUserWrite'; e={$_.'Last User Write'}}
    $col16 = @{n='Created'; e={$_.'Created'}}
    $col17 = @{n='Modified'; e={$_.'Last Modified'}}
    $col18 = @{n='PageLatchWaitCount'; e={$_.'Page Latch Wait Count'}}
    $col19 = @{n='PageLatchWaitTime'; e={$_.'Page Latch Wait Time (D:H:M:S)'}}
    $col20 = @{n='PageIOLatchWaitCount'; e={$_.'Page IO Latch Wait Count'}}
    $col21 = @{n='PageIOLatchWaitTime'; e={$_.'Page IO Latch Wait Time (D:H:M:S)'}}
    $col22 = @{n='Create'; e={$_.'Create TSQL'}}
    $col23 = @{n='Drop'; e={$_.'Drop TSQL'}}

    # Les Templates permettent de choisir une liste de colonnes pour une table
    $t0All = @{
        Property = @($col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10,$col11,$col12,$col13,$col14,$col15,$col16,$col17,$col18,$col19,$col20,$col21,$col22,$col23)
    }
    $t0Simple = @{
        Property = @($col1,$col2,$col7,$col5)
    }
    #endregion

    # la première ligne ne fait qu'afficher le uptime (-skip 1)
    # Il y a toujours 6 recordsets retournés

    if ($Template -eq 'Simple') {
        $cliXml.Tables[0] | Select-Object @t0Simple -skip 1 | Out-String
        if ($cliXml.Tables[1][0] -ne 'No missing indexes.') {
            $cliXml.Tables[1] | Format-Table | Out-String
        }
        $cliXml.Tables[2] | Format-Table | Out-String
        $cliXml.Tables[3] | Format-Table | Out-String
        $cliXml.Tables[4] | Format-Table | Out-String
        $cliXml.Tables[5] | Format-Table | Out-String
    } else {
        $cliXml.Tables[0] | Select-Object @t0All -skip 1
    }

}