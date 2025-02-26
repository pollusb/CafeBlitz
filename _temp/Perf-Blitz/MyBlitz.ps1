$MyBlitzRoot = "$home\Code\Temp" # Racine de la cache
#$exclExcelCol = 'RowError','HasError','RowState','Table','ItemArray'
mkdir $MyBlitzRoot -ErrorAction silentlycontinue | Out-Null

# WISH: Ne pas créer de dossier avec le nom de l'instance

<#
    .NOTES
    +1
    Invoke-BlitzMachin -> Retourner un objet DataSet (maintenant PSObjectArray)
    ConsultantToolKit -SqlInstance -ZipPath

    Racine de la cache ?
     + SQ-PBDD22
       + BI_1
         + 1 <- numéro d'execution
           + Cache
             + cpu
             + reads
             + ...
           + First
           + Health
           + Indexes <- pour les différents mode
           + Database
             + Table <- pour chaque table
           + Script
             + Database <- les tables, vues, procédures, fonctions, triggers
             + Perf     <- Eliminate.sql, Dedupe.sql, etc.
#>

<#
	    @SkipBlockingChecks TINYINT = 1 ,
        @BringThePain TINYINT = 0 ,
        @CheckProcedureCache TINYINT = 0 ,
        @CheckServerInfo TINYINT = 0 ,
        @CheckUserDatabaseObjects TINYINT = 1 ,
        @IgnorePrioritiesAbove INT = NULL ,
        @IgnorePrioritiesBelow INT = NULL ,
        @OutputProcedureCache TINYINT = 0 ,
        @OutputXMLasNVARCHAR TINYINT = 0 ,
        @SummaryMode TINYINT = 0 ,
        @VersionCheckMode BIT = 0
        Debug TINYINT = 0 ,
		@Help TINYINT = 0 ,

    @CheckProcedureCacheFilter VARCHAR(10) = NULL ,
    @EmailProfile sysname = NULL ,
    @EmailRecipients VARCHAR(MAX) = NULL ,
    @OutputDatabaseName NVARCHAR(256) = NULL ,
    @OutputSchemaName NVARCHAR(256) = NULL ,
    @OutputServerName NVARCHAR(256) = NULL ,
    @OutputTableName NVARCHAR(256) = NULL ,
    @OutputType VARCHAR(20) = 'TABLE' ,
    @SkipChecksDatabase NVARCHAR(256) = NULL ,
    @SkipChecksSchema NVARCHAR(256) = NULL ,
    @SkipChecksServer NVARCHAR(256) = NULL ,
    @SkipChecksTable NVARCHAR(256) = NULL ,
    @UsualDBOwner sysname = NULL ,
    @Version     VARCHAR(30) = NULL OUTPUT,
	@VersionDate DATETIME = NULL OUTPUT,

-- https://www.brentozar.com/blitz/documentation/
#>
function Invoke-Blitz {
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        $Database = $DbaDatabaseName,

        [switch]$CheckUserDatabaseObjects,#

        [switch]$CheckServerInfo,#

        [switch]$CheckProcedureCache,

        [switch]$OutputProcedureCache,

        [ValidateSet('CPU','Reads','Duration','ExecCount','','','','')]
        [string]$CheckProcedureCacheFilter,

        [ValidateSet('TABLE','COUNT','MARKDOWN','SCHEMA','XML','NONE')]
        [string]$OutputType,

        [int]$IgnorePrioritiesBelow,

        [int]$IgnorePrioritiesAbove
    )
    $query = "EXEC $Database.dbo.sp_Blitz "
    if ($CheckUserDatabaseObjects)  {$query += "@CheckUserDatabaseObjects = 1, "}
    if ($CheckServerInfo)           {$query += "@CheckServerInfo = 1, "}
    if ($CheckProcedureCache)       {$query += "@CheckProcedureCache = 1, "}
    if ($OutputProcedureCache)      {$query += "@OutputProcedureCache = 1, "}
    if ($CheckProcedureCacheFilter) {$query += "@CheckProcedureCacheFilter = '$CheckProcedureCacheFilter', "}
    if ($IgnorePrioritiesBelow)     {$query += "@IgnorePrioritiesBelow = 1, "}
    if ($IgnorePrioritiesAbove)     {$query += "@IgnorePrioritiesAbove = 1, "}
    $query = $query -replace ', $',';'
    write-Verbose $query
return
    foreach ($sql in $SqlInstance) {
        # Retourne 1 table
        Invoke-DbaQuery -SqlInstance $sql -Query $query -As PSObjectArray
    }
}
function Invoke-BlitzFirst {
    param (
        [Parameter(Mandatory)]
        $SqlInstance
    )
    foreach ($sql in $SqlInstance) {
        $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzFirst @SinceStartup = 1;"

        # Retourne 3 tables {WAIT STATS; PHYSICAL READS/WRITES; PERFMON}
        Invoke-DbaQuery -SqlInstance $sql -Query $query -As PSObjectArray
    }
}
function Invoke-BlitzIndexAllDatabases {
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        [Parameter(Mandatory)]
        [ValidateRange(0, 4)]
        $Mode # All returns only one table but with different columns
    )
    foreach ($sql in $SqlInstance) {
        $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzIndex @Mode = $Mode, @GetAllDatabases = 1;"

        # Retourne toujours 1 table
        Invoke-DbaQuery -SqlInstance $sql -Query $query -As PSObjectArray
    }
}
function Invoke-BlitzIndexTable {
    # À revoir. Je devrais créer un objet meta ?
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        $Database, # All by default

        $Table # All by default
    )
    foreach ($sql in $SqlInstance) {
        $tables = Get-DbaDbTable -SqlInstance $SqlInstance -Database $Database -ExcludeDatabase $DbaDatabaseName, master, msdb, tempdb, model -Table $Table
        $I = 0
        foreach ($tbl in $tables) {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzIndex @DatabaseName='{0}', @SchemaName='{1}', @TableName='{2}';" -f $tbl.Database, $tbl.Schema, $tbl.Name
            $result = Invoke-DbaQuery -SqlInstance $sql -Query $query -As DataSet
            $fileClixml = '{0}\{1}\Database\{2}\Table\{3}.{4}.blitz.index.xml' -f $RootPath, $sql, $tbl.Database, $tbl.Schema, $tbl.Name
            mkdir "$RootPath\$($sql.ToUpper())\Database\$($tbl.Database)\Table" -ea SilentlyContinue | Select-Object -ExpandProperty Fullname
            $result | Export-Clixml -Path $fileClixml
            Write-Verbose $query
            Write-Verbose $fileClixml
            $status = '[{0}].{1}.{2} ' -f $tbl.Database, $tbl.Schema, $tbl.Name
            Write-Progress -Activity "Executing sp_BlitzIndex on [$sql]" -Status $status -PercentComplete (100 * (++$I) / $tables.Count)
            [PSCustomObject]@{
                OutputFile = $fileClixml
            }
        }
    }
}
function Invoke-BlitzCache {
    # Retirer exporter les plans. Retourne un objet meta
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $SqlInstance,

        #[string]$ExportPlanPath,        # Export plans only if a path is provided

        #[switch]$UseLongExportPlanPath, # Inject SqlInstance\Cache\SortOrder in path

        [string]$Database, # All user databases by default, else only one database is permitted

        [ValidateSet('cpu', 'reads', 'writes', 'duration', 'executions', 'recent compilation', 'memory grant', 'unused grant', 'spills', 'xpm')]
        $SortOrder = 'cpu'
    )
    foreach ($sql in $SqlInstance) {
        if ($Database) {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzCache @DatabaseName='$Database', @SortOrder='$SortOrder', @ExpertMode=1;"
        }
        else {
            $query = "EXEC $DbaDatabaseName.dbo.sp_BlitzCache @SortOrder='$SortOrder', @ExpertMode=1;"
        }
        Write-Verbose "Running:$query"
        Invoke-DbaQuery -SqlInstance $sql -Query $query -As PSObjectArray
    }
}
function ConsultantToolKit {
    # Générer tous les datasets et exporter vers CliXml
    # et éventuellement vers Excel pour ressembler à BrentOzar Consultant Tool Kit
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [string]$ZipPath = (Get-Location) # Pour déposer le fichier dans ce dossier à la fin du traitement
    )
    $now = Get-Date
    $execRoot = mkdir ('{0}\{1}' -f $env:TEMP, (Get-Random -Maximum 9999))
    $zipFile = '{0}\{1}_{2}.zip' -f $ZipPath, $SqlInstance.Replace('\', '_'), (Get-Date -f 'yyyyMMdd-HHmm')
    $act = "Create package $zipFile"

    #region Health & Uptime

    $Theme = 'Health'
    Write-Progress -Activity $act -Status $Theme -PercentComplete 5
    Write-Verbose 'Health'
    $ds = Invoke-BlitzHealth -SqlInstance $SqlInstance
    $ds | Export-Clixml -Path "$execRoot\1-Health.xml"
    $uptime = Get-DbaUptime -SqlInstance $SqlInstance
    $uptime | Export-Clixml -Path "$execRoot\1-Uptime.xml"

    #endregion

    #region Index

    $Theme = 'Index Mode 2'
    Write-Progress -Activity $act -Status $Theme -PercentComplete 10
    $ds = Invoke-BlitzIndexAllDatabases -SqlInstance $SqlInstance -Mode 2
    $ds | Export-Clixml -Path "$execRoot\2-IndexM2.xml"

    $Theme = 'Index Mode 4'
    Write-Progress -Activity $act -Status $Theme -PercentComplete 15
    $ds = Invoke-BlitzIndexAllDatabases -SqlInstance $SqlInstance -Mode 4
    $ds | Export-Clixml -Path "$execRoot\2-IndexM4.xml"

    #endregion

    #region First

    $Theme = 'Wait stats'
    Write-Progress -Activity $act -Status $Theme -PercentComplete 20
    $ds = Invoke-BlitzFirst -SqlInstance $SqlInstance
    $ds | Export-Clixml -Path "$execRoot\3-First.xml"

    #endregion

    #region Cache

    $sorts = @('cpu', 'reads', 'writes', 'duration', 'executions', 'recent compilation', 'memory grant', 'unused grant', 'spills', 'xpm')
    $p = 20 # jusqu'a 70
    foreach ($sort in $sorts) {
        $Theme = "Plan cache $sort"
        Write-Progress -Activity $act -Status $Theme -PercentComplete ($p += 5)
        $ds = Invoke-BlitzCache -SqlInstance $SqlInstance -SortOrder $sort
        $ds | Export-Clixml -Path "$execRoot\4-Cache-$sort.xml"
    }

    #endregion

    #region zipfile

    Write-Progress -Activity $act -Status 'Create a ZIP file' -PercentComplete 95
    Compress-Archive -Path $execRoot -DestinationPath $zipFile
    Write-Progress -Activity $act -Status 'Completed' -Completed
    $timeElapse = New-TimeSpan -Start $now -End (Get-Date)
    [PSCustomObject]@{
        SqlInstance = $SqlInstance
        Uptime      = $uptime.SqlUptime
        Archive     = $zipFile
        Date        = $now
        TimeElapse  = $timeElapse
    }

    #endregion
}

#endregion

#region Zip to CliXml to Excel

function Export-Excel {
    param (
        [ValidateScript({ Test-Path $_ -PathType Container })]
        $Path
    )
    # Export vers Excel

    # Export des plans


}

function Rename-Columns {
    # Array of HashTable splat to rename columns in Select-Object (TSQL SELECT [col with space] as colwithspace)
    param (
        [string[]]$Columns,
        [hashtable]$RenamePattern = @{Replace='\s|:.+';With=''}
    )
    #$return = @()
    foreach ($col in $Columns) {
        #$expr = Invoke-Expression "$_.$col"
        $newName = $col -replace $RenamePattern['Replace'], $RenamePattern['With']
        @{n=$newName;e={$_.$col}.GetNewClosure()}
        #$return += @{n="$newName";e=$expr}
    }
    #$return
}

function Format-BlitzHealth {
    <#
    .SYNOPSIS
    Pour lire les fichiers de type .bzfirst.xml
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
    $col1 = @{n = 'Details'; e = { $_.'Details: db_schema.table.index(indexid)' } }
    $col2 = @{n = 'Definition'; e = { $_.'Definition: [Property] ColumnName {datatype maxbytes}' } }
    $col3 = @{n = 'SecretCol'; e = { $_.'Secret Columns' } }
    $col4 = @{n = 'Fillfactor'; e = { $_.'Fillfactor' } }
    $col5 = @{n = 'UsageStat'; e = { $_.'Usage Stats' } }
    $col6 = @{n = 'OpStats'; e = { $_.'Op Stats' } }
    $col7 = @{n = 'Size'; e = { $_.'Size' } }
    $col8 = @{n = 'Compress'; e = { $_.'Compression Type' } }
    $col9 = @{n = 'LockW'; e = { $_.'Lock Waits' } }
    $col10 = @{n = 'RefByFK'; e = { $_.'Referenced by FK?' } }
    $col11 = @{n = 'FKCovered'; e = { $_.'FK Covered by Index?' } }
    $col12 = @{n = 'LastUserSeek'; e = { $_.'Last User Seek' } }
    $col13 = @{n = 'LastUserScan'; e = { $_.'Last User Scan' } }
    $col14 = @{n = 'LastUserLookup'; e = { $_.'Last User Lookup' } }
    $col15 = @{n = 'LastUserWrite'; e = { $_.'Last User Write' } }
    $col16 = @{n = 'Created'; e = { $_.'Created' } }
    $col17 = @{n = 'Modified'; e = { $_.'Last Modified' } }
    $col18 = @{n = 'PageLatchWaitCount'; e = { $_.'Page Latch Wait Count' } }
    $col19 = @{n = 'PageLatchWaitTime'; e = { $_.'Page Latch Wait Time (D:H:M:S)' } }
    $col20 = @{n = 'PageIOLatchWaitCount'; e = { $_.'Page IO Latch Wait Count' } }
    $col21 = @{n = 'PageIOLatchWaitTime'; e = { $_.'Page IO Latch Wait Time (D:H:M:S)' } }
    $col22 = @{n = 'Create'; e = { $_.'Create TSQL' } }
    $col23 = @{n = 'Drop'; e = { $_.'Drop TSQL' } }

    # Les Templates permettent de choisir une liste de colonnes pour une table
    $t0All = @{
        Property = @($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10, $col11, $col12, $col13, $col14, $col15, $col16, $col17, $col18, $col19, $col20, $col21, $col22, $col23)
    }
    $t0Simple = @{
        Property = @($col1, $col2, $col7, $col5)
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
    }
    else {
        $cliXml.Tables[0] | Select-Object @t0All -skip 1
    }

}
function IndexTable2Excel {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        $DataSet,

        [Parameter(Mandatory)]
        $ExcelFile
    )
    foreach ($id in 0..5) {
        $splat = @{
            Path          = $ExcelFile
            WorksheetName = "Index$id"
            TableName     = "Table_Index$id"
            BoldTopRow    = $true
            AutoFilter    = $true
            AutoSize      = $true
        }
        $cols = @()
        # Ne pas exporter les colonnes vides (ou les cacher ?)
        $table = $DataSet.Tables[$id]
        foreach ($col in $table.Columns) {
            if (($table | Where-Object { -not [string]::IsNullOrEmpty($_.$col) }).Count -eq 0) {
                Write-Verbose "Empty column : $col"
            }
            else {
                $cols += [string]$col

            }
        }
        write-Verbose "Index$id"
        Write-Verbose ($cols -join ',')
        $table | Select-Object -Property $cols | Export-Excel @splat
        Write-Verbose $ExcelFile

        $table | Export-Excel @splat
    }
}
function IndexAllDatabases2Excel {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        $DataSet,

        [Parameter(Mandatory)]
        $ExcelFile,

        $TabName = 'Mode2'
    )
    $splat = @{
        Path          = $ExcelFile
        WorksheetName = $TabName
        TableName     = "Table_$TabName"
        BoldTopRow    = $true
        AutoFilter    = $true
        AutoSize      = $true
    }

    #region Colonnes
    $excelColumnMode2 = "Name,NewName,Hide,Group
Database Name,
Schema Name,
Object Name,
Index Name,
Index ID,,1
Details: schema.table.index(indexid),Details
Object Type,
Definition: [Property] ColumnName {datatype maxbytes},Definition
Key Column Names With Sort,
Count Key Columns,
Include Column Names,
Count Included Columns,
Secret Column Names,
Count Secret Columns,
Partition Key Column Name,
Filter Definition,
Is Indexed View,,,1
Is Primary Key,,,1
Is XML,,,1
Is Spatial,,,1
Is NC Columnstore,,,1
Is CX Columnstore,,,1
Is In-Memory OLTP,,,1
Is Disabled,,,1
Is Hypothetical,,,1
Is Padded,,,1
Fill Factor,,,1
Is Reference by Foreign Key,,,1
Last User Seek,
Last User Scan,
Last User Lookup,
Last User Update,
Total Reads,
User Updates,
Reads Per Write,
Index Usage,
Singleton Lookups,
Range Scans,
Leaf Deletes,
Leaf Updates,
Index Op Stats,
Partition Count,
Rows,
Reserved MB,
Reserved LOB MB,
Reserved Row Overflow MB,
Index Size,
Row Lock Count,
Row Lock Wait Count,
Row Lock Wait ms,
Avg Row Lock Wait ms,
Page Lock Count,
Page Lock Wait Count,
Page Lock Wait ms,
Avg Page Lock Wait ms,
Lock Escalation Attempts,
Lock Escalations,
Page Latch Wait Count,
Page Latch Wait ms,
Page IO Latch Wait Count,
Page IO Latch Wait ms,
Forwarded Fetches,
Data Compression,
Create Date,
Modify Date,
More Info,
Drop TSQL,
Create TSQL,
Display Order,
" | ConvertFrom-Csv
    #endregion

    <#
    Comment renommer les colonnes ? Je peux le faire avec Select-Object
    Comment cacher les colonnes ? Set-ExcelColumn
    Comment grouper les colonnes ? Set-ExcelRange
    Comment mettre en valeur des cellules ? avec ConditionalFormat ?
    #>

    $cols = @()
    # Ne pas exporter les colonnes vides (ou les cacher ?)
    $table = $DataSet.Tables[0]
    foreach ($col in $table.Columns) {
        if (($table | Where-Object { -not [string]::IsNullOrEmpty($_.$col) }).Count -eq 0) {
            Write-Verbose "Empty column : $col"
        }
        else {
            if ($thisCol = $excelColumnMode2 | Where-Object Name -eq $col) {
                if ($thisCol.NewName) {
                    $cols += @{
                        Name       = $thisCol.NewName
                        Expression = { $thisCol.$col }
                    }
                }
                else {
                    $cols += [string]$col
                    Write-Verbose "Found in CSV but no NewName:$col"
                }
            }
            else {
                #$cols += [string]$col
                Write-Verbose "Not found in CSV:$col"
            }
        }
    }
    $cols
    return

    Write-Verbose $TabName
    Write-Verbose ($cols -join ',')

    $table | Select-Object -Property $cols | Export-Excel @splat
    Write-Verbose $ExcelFile

    $table | Export-Excel @splat
}
function Format-BlitzFirst {
    <#
    .SYNOPSIS
    Pour lire les fichiers de type .blitz.first.xml
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
    $col1 = @{n = 'Details'; e = { $_.'Details: db_schema.table.index(indexid)' } }
    $col2 = @{n = 'Definition'; e = { $_.'Definition: [Property] ColumnName {datatype maxbytes}' } }
    $col3 = @{n = 'SecretCol'; e = { $_.'Secret Columns' } }
    $col4 = @{n = 'Fillfactor'; e = { $_.'Fillfactor' } }
    $col5 = @{n = 'UsageStat'; e = { $_.'Usage Stats' } }
    $col6 = @{n = 'OpStats'; e = { $_.'Op Stats' } }
    $col7 = @{n = 'Size'; e = { $_.'Size' } }
    $col8 = @{n = 'Compress'; e = { $_.'Compression Type' } }
    $col9 = @{n = 'LockW'; e = { $_.'Lock Waits' } }
    $col10 = @{n = 'RefByFK'; e = { $_.'Referenced by FK?' } }
    $col11 = @{n = 'FKCovered'; e = { $_.'FK Covered by Index?' } }
    $col12 = @{n = 'LastUserSeek'; e = { $_.'Last User Seek' } }
    $col13 = @{n = 'LastUserScan'; e = { $_.'Last User Scan' } }
    $col14 = @{n = 'LastUserLookup'; e = { $_.'Last User Lookup' } }
    $col15 = @{n = 'LastUserWrite'; e = { $_.'Last User Write' } }
    $col16 = @{n = 'Created'; e = { $_.'Created' } }
    $col17 = @{n = 'Modified'; e = { $_.'Last Modified' } }
    $col18 = @{n = 'PageLatchWaitCount'; e = { $_.'Page Latch Wait Count' } }
    $col19 = @{n = 'PageLatchWaitTime'; e = { $_.'Page Latch Wait Time (D:H:M:S)' } }
    $col20 = @{n = 'PageIOLatchWaitCount'; e = { $_.'Page IO Latch Wait Count' } }
    $col21 = @{n = 'PageIOLatchWaitTime'; e = { $_.'Page IO Latch Wait Time (D:H:M:S)' } }
    $col22 = @{n = 'Create'; e = { $_.'Create TSQL' } }
    $col23 = @{n = 'Drop'; e = { $_.'Drop TSQL' } }

    # Les Templates permettent de choisir une liste de colonnes pour une table
    $t0All = @{
        Property = @($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10, $col11, $col12, $col13, $col14, $col15, $col16, $col17, $col18, $col19, $col20, $col21, $col22, $col23)
    }
    $t0Simple = @{
        Property = @($col1, $col2, $col7, $col5)
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
    }
    else {
        $cliXml.Tables[0] | Select-Object @t0All -skip 1
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
    $col1 = @{n = 'Details'; e = { $_.'Details: db_schema.table.index(indexid)' } }
    $col2 = @{n = 'Definition'; e = { $_.'Definition: [Property] ColumnName {datatype maxbytes}' } }
    $col3 = @{n = 'SecretCol'; e = { $_.'Secret Columns' } }
    $col4 = @{n = 'Fillfactor'; e = { $_.'Fillfactor' } }
    $col5 = @{n = 'UsageStat'; e = { $_.'Usage Stats' } }
    $col6 = @{n = 'OpStats'; e = { $_.'Op Stats' } }
    $col7 = @{n = 'Size'; e = { $_.'Size' } }
    $col8 = @{n = 'Compress'; e = { $_.'Compression Type' } }
    $col9 = @{n = 'LockW'; e = { $_.'Lock Waits' } }
    $col10 = @{n = 'RefByFK'; e = { $_.'Referenced by FK?' } }
    $col11 = @{n = 'FKCovered'; e = { $_.'FK Covered by Index?' } }
    $col12 = @{n = 'LastUserSeek'; e = { $_.'Last User Seek' } }
    $col13 = @{n = 'LastUserScan'; e = { $_.'Last User Scan' } }
    $col14 = @{n = 'LastUserLookup'; e = { $_.'Last User Lookup' } }
    $col15 = @{n = 'LastUserWrite'; e = { $_.'Last User Write' } }
    $col16 = @{n = 'Created'; e = { $_.'Created' } }
    $col17 = @{n = 'Modified'; e = { $_.'Last Modified' } }
    $col18 = @{n = 'PageLatchWaitCount'; e = { $_.'Page Latch Wait Count' } }
    $col19 = @{n = 'PageLatchWaitTime'; e = { $_.'Page Latch Wait Time (D:H:M:S)' } }
    $col20 = @{n = 'PageIOLatchWaitCount'; e = { $_.'Page IO Latch Wait Count' } }
    $col21 = @{n = 'PageIOLatchWaitTime'; e = { $_.'Page IO Latch Wait Time (D:H:M:S)' } }
    $col22 = @{n = 'Create'; e = { $_.'Create TSQL' } }
    $col23 = @{n = 'Drop'; e = { $_.'Drop TSQL' } }

    # Les Templates permettent de choisir une liste de colonnes pour une table
    $t0All = @{
        Property = @($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10, $col11, $col12, $col13, $col14, $col15, $col16, $col17, $col18, $col19, $col20, $col21, $col22, $col23)
    }
    $t0Simple = @{
        Property = @($col1, $col2, $col7, $col5)
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
    }
    else {
        $cliXml.Tables[0] | Select-Object @t0All -skip 1
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
    $col1 = @{n = 'Details'; e = { $_.'Details: db_schema.table.index(indexid)' } }
    $col2 = @{n = 'Definition'; e = { $_.'Definition: [Property] ColumnName {datatype maxbytes}' } }
    $col3 = @{n = 'SecretCol'; e = { $_.'Secret Columns' } }
    $col4 = @{n = 'Fillfactor'; e = { $_.'Fillfactor' } }
    $col5 = @{n = 'UsageStat'; e = { $_.'Usage Stats' } }
    $col6 = @{n = 'OpStats'; e = { $_.'Op Stats' } }
    $col7 = @{n = 'Size'; e = { $_.'Size' } }
    $col8 = @{n = 'Compress'; e = { $_.'Compression Type' } }
    $col9 = @{n = 'LockW'; e = { $_.'Lock Waits' } }
    $col10 = @{n = 'RefByFK'; e = { $_.'Referenced by FK?' } }
    $col11 = @{n = 'FKCovered'; e = { $_.'FK Covered by Index?' } }
    $col12 = @{n = 'LastUserSeek'; e = { $_.'Last User Seek' } }
    $col13 = @{n = 'LastUserScan'; e = { $_.'Last User Scan' } }
    $col14 = @{n = 'LastUserLookup'; e = { $_.'Last User Lookup' } }
    $col15 = @{n = 'LastUserWrite'; e = { $_.'Last User Write' } }
    $col16 = @{n = 'Created'; e = { $_.'Created' } }
    $col17 = @{n = 'Modified'; e = { $_.'Last Modified' } }
    $col18 = @{n = 'PageLatchWaitCount'; e = { $_.'Page Latch Wait Count' } }
    $col19 = @{n = 'PageLatchWaitTime'; e = { $_.'Page Latch Wait Time (D:H:M:S)' } }
    $col20 = @{n = 'PageIOLatchWaitCount'; e = { $_.'Page IO Latch Wait Count' } }
    $col21 = @{n = 'PageIOLatchWaitTime'; e = { $_.'Page IO Latch Wait Time (D:H:M:S)' } }
    $col22 = @{n = 'Create'; e = { $_.'Create TSQL' } }
    $col23 = @{n = 'Drop'; e = { $_.'Drop TSQL' } }

    # Les Templates permettent de choisir une liste de colonnes pour une table
    $t0All = @{
        Property = @($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10, $col11, $col12, $col13, $col14, $col15, $col16, $col17, $col18, $col19, $col20, $col21, $col22, $col23)
    }
    $t0Simple = @{
        Property = @($col1, $col2, $col7, $col5)
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
    }
    else {
        $cliXml.Tables[0] | Select-Object @t0All -skip 1
    }

}
function Export-Health2Excel {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        $PSObject,

        [Parameter(Mandatory)]
        $ExcelFile
    )
    $splat = @{
        Path          = $ExcelFile
        WorksheetName = "Health"
        TableName     = "Table_Health"
        BoldTopRow    = $true
        AutoFilter    = $true
        AutoSize      = $true
    }
    $cols = @()
    # Ne pas exporter les colonnes vides (ou les cacher ?)
    $table = $PSObject.Tables[0]
    foreach ($col in $table.Columns) {
        if (($table | Where-Object { -not [string]::IsNullOrEmpty($_.$col) }).Count -eq 0) {
            Write-Verbose "Empty column : $col"
        }
        else {
            $cols += [string]$col

        }
    }
    Write-Verbose ($cols -join ',')
    $table | Select-Object -Property $cols  | Export-Excel @splat
    Write-Verbose $ExcelFile
}

#endregion