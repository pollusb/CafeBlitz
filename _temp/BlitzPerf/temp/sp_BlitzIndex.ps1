function Invoke-BlitzIndex {
    <#
    .SYNOPSIS
    Pour générer des fichiers de type .blitz.index.xml pour chaque table ou pour MODE = 2 ou 4
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        [ValidateSet("mode2", "mode4")]
        $BlitzParam = $null,

        $Database = @('Rcpd1A','RcpdAbstract1A','RcpdCommunBi1A','RcpdStagingAdhoc1A','RcpdStagingCME1A','RcpdStagingDTCC1A','RcpdStagingICE1A','RcpdBi1A'),

        $Table, # All by default

        $Path = "$home\Code\Temp" # $Path\SQ-DBDD20\BI_1\Database\Rcpd1A\Table\RcpdBusiness.BridgeBusinessReportingTransactionDtccIr.blitz.index.xml
    )
    function crdir ($Path) {
        mkdir $Path -ea SilentlyContinue | Select-Object Fullname | Out-Verbose
    }
    foreach ($sql in $SqlInstance) {
        crdir "$Path\$($sql.ToUpper())"
        if ($BlitzParam -eq 'mode2') {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzIndex @Mode = 2, @GetAllDatabases = 1"
            $result = Invoke-DbaQuery -SqlInstance $sql -Query $query -As DataSet
            $fileClixml = '{0}\{1}\Mode2.blitz.index.xml' -f $Path, $sql
            $result | Export-Clixml -Path $fileClixml
            Write-Verbose $query
            Write-Verbose $fileClixml
        } elseif ($BlitzParam -eq 'mode4') {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzIndex @Mode = 4, @GetAllDatabases = 1"
            $result = Invoke-DbaQuery -SqlInstance $sql -Query $query -As DataSet
            $fileClixml = '{0}\{1}\Mode4.blitz.index.xml' -f $Path, $sql
            $result | Export-Clixml -Path $fileClixml
            Write-Verbose $query
            Write-Verbose $fileClixml
        } else {
            $tables = Get-DbaDbTable -SqlInstance $SqlInstance -Database $Database -ExcludeDatabase $DbaDatabaseName,master,msdb,tempdb,model -Table $Table
            $I = 0
            foreach ($tbl in $tables) {
                $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzIndex @DatabaseName='{0}', @SchemaName='{1}', @TableName='{2}';" -f $tbl.Database, $tbl.Schema, $tbl.Name
                $result = Invoke-DbaQuery -SqlInstance $sql -Query $query -As DataSet
                $fileClixml = '{0}\{1}\Database\{2}\Table\{3}.{4}.blitz.index.xml' -f $Path, $sql, $tbl.Database, $tbl.Schema, $tbl.Name
                mkdir "$Path\$($sql.ToUpper())\Database\$($tbl.Database)\Table" -ea SilentlyContinue | Select-Object Fullname | Out-Verbose
                $result | Export-Clixml -Path $fileClixml
                Write-Verbose $query
                Write-Verbose $fileClixml
                $status = '[{0}].{1}.{2} ' -f $tbl.Database, $tbl.Schema, $tbl.Name
                Write-Progress -Activity "Executing sp_BlitzIndex on [$sql]" -Status $status -PercentComplete (100*(++$I)/$tables.Count)
            }
        }
    }
}

function Format-BlitzIndex {
    <#
    .SYNOPSIS
    Pour lire les fichiers de type .blitz.index.xml
    Montrer le contenu du fichier avec des modifs suivantes:
    - retrait des colonnes ou il n'y a pas d'info
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