<#
.SYNOPSIS
    Wrapper function for sp_BlitzIndex
.DESCRIPTION

.NOTES
    1. Parameters that are true by default are renamed DoNot*. As an example, @SkipStatistics = 1 by default. To disable, you need to use the switch -DoNotSkipStatistics
    2. Some parameters are ignored like @Help, @Version or @Debug
    3. -Verbose option will generate the EXEC string with all parameters
    4. Some parameters combinaison can't be used. This logic is implemented in the sproc code and will return a warning
    TODO: a parameter to return only 1 table and merge with SqlInstance and columns renamed (they don't need it now)
#>
function Invoke-CafeBlitzIndex {
    [CmdLetBinding()]
    param (
        [string[]]$SqlInstance,

        [Alias('Database')]
        [string]$DatabaseName, # NVARCHAR(128) = NULL, Defaults to current DB if not specified
        [Alias('Schema')]
        [string]$SchemaName, # NVARCHAR(128) = NULL, Requires table_name as well
        [Alias('Table')]
        [string]$TableName, # NVARCHAR(128) = NULL, Requires schema_name as well

        [ValidateRange(0, 4)] # @Mode doesn't matter if you're specifying @SchemaName and @TableName
        [byte]$Mode = 0, # TINYINT=0, 0=Diagnose, 1=Summarize, 2=Index Usage Detail, 3=Missing Index Detail, 4=Diagnose Details

        [ValidateRange(0, 2)] # @Filter doesn't do anything unless @Mode=0
        [byte]$Filter = 0, # TINYINT = 0, 0=no filter (default). 1=No low-usage warnings for objects with 0 reads. 2=Only warn for objects >= 500MB

        [switch]$SkipPartitions, # BIT = 0
        [switch]$DoNotSkipStatistics, # @SkipStatistics BIT = 1
        [switch]$GetAllDatabases, # BIT = 0
        [switch]$ShowColumnstoreOnly, # BIT = 0, Will show only the Row Group and Segment details for a table with a columnstore index
        [switch]$BringThePain, # BIT = 0
        [int]$ThresholdMB = 250, # INT = 250 Number of megabytes that an object must be before we include it in basic results
        [string]$IgnoreDatabases, # NVARCHAR(MAX) = NULL, Comma-delimited list of databases you want to skip

        # This parameter will also change the output of the function
        [ValidateSet('TABLE', 'NONE')]
        [string]$OutputType = 'TABLE',

        [string]$OutputServerName, # NVARCHAR(256) = NULL
        [string]$OutputDatabaseName, # NVARCHAR(256) = NULL
        [string]$OutputSchemaName, # NVARCHAR(256) = NULL
        [string]$OutputTableName, # NVARCHAR(256) = NULL

        [switch]$IncludeInactiveIndexes, # BIT = 0, Will skip indexes with no reads or writes
        [switch]$ShowAllMissingIndexRequests, # BIT = 0, Will make all missing index requests show up
        [switch]$ShowPartitionRanges, # BIT = 0, Will add partition range values column to columnstore visualization
        [string]$SortOrder, # NVARCHAR(50) = NULL, Only affects @Mode = 2.
        [string]$SortDirection, # NVARCHAR(4) = 'DESC', Only affects @Mode = 2.
        # @Help TINYINT = 0
        # @Debug BIT = 0
        # @Version VARCHAR(30) = NULL
        # @VersionDate DATETIME = NULL
        # @VersionCheckMode BIT = 0

        [switch]$DoNotRenameColumns, # By default, property names will be renamed to remove space and special characters
        [switch]$JoinResults # By default, it will return an object for each SqlInstance. Using this will merge the result and append the SqlInstance
    )
    $spname = 'sp_BlitzIndex'
    $sprocPath = (Resolve-Path "$PSScriptRoot\..\tsql\$spname.temp.sql").Path

    # Making assumptions about parameters
    $param = @()
    if (!($DatabaseName -or $GetAllDatabases)) {
        Write-Warning 'No database passed, assuming GetAllDatabases'
        $GetAllDatabases = $true
        $param += '@GetAllDatabases = 1'
    }
    # Building EXEC command using PSBoundParameters
    $ignore = @()
    $param += foreach ($bp in $PSBoundParameters.GetEnumerator()) {
        if ($bp.Key -match 'JoinResults|DoNotRenameColumns|SqlInstance|Verbose|OutVariable|Debug|ErrorAction|WarningAction|InformationAction|ErrorVariable|WarningVariable|InformationVariable|OutBuffer|PipelineVariable') {
            $ignore += $bp.Key
        }
        elseif ($bp.Key -match 'Output|Ignore|Name|Sort') {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
            Write-Verbose "$($bp.Key) #1"
        }
        elseif ($bp.Key -like 'DoNot*') {
            "@{0} = 0" -f ($bp.Key -replace '^DoNot')
            Write-Verbose "$($bp.Key) #2"
        }
        elseif ($bp.Value -eq $true) {
            "@{0} = 1" -f $bp.Key
            Write-Verbose "$($bp.Key) #3"
        }
        else {
            "@{0} = {1}" -f $bp.Key, $bp.Value
            Write-Verbose "$($bp.Key) #else"
        }
    }
    Write-Verbose "Ignored param ($($ignore -join ', '))"
    $query = "EXEC #$spname " + ($param -join ', ')
    Write-Verbose $sprocPath
    Write-Verbose "Query used:`n$query"
return
    foreach ($sql in $SqlInstance) {
        # NonPooledConnection to reuse connection
        $smo = Connect-DbaInstance -SqlInstance $sql -DisableException -TrustServerCertificate -NonPooledConnection
        if ($smo) {
            # Create temp stored procedure
            Invoke-DbaQuery -SqlInstance $smo -File $sprocPath

            # Execute temp stored procedure
            switch ($OutputType) {
                'TABLE' {
                    $data = Invoke-DbaQuery -SqlInstance $smo -Query $query -As DataRow
                    if ($data.psobject.properties.Name -contains 'BringThePain') {
                        Write-Warning "$sql : $($data|Out-String)"
                    }
                }
                'NONE' { # NOTE: this option will most probably be removed
                    Invoke-DbaQuery -SqlInstance $smo -Query $query -MessagesToOutput | Write-Output
                    return
                }
            }

            # Rename property names
            $result = if ($DoNotRenameColumns) {
                ConvertFrom-DataRows -InputObject $data -RenameColumn $null
            } else {
                ConvertFrom-DataRows -InputObject $data -RenameColumn @{ Replace = '\s+|\?|:.*|\(.*'; With = '' }
            }

            # TODO: Remove unuseful lines and columns

            if ($JoinResults) {
                $result | ForEach-Object { $_ | Add-Member -NotePropertyName SqlInstance -NotePropertyValue $sql }
                $result
            }
            else {
                [PSCustomObject]@{
                    SqlInstance = $sql.ToUpper()
                    Date        = Get-Date
                    Version     = Find-BlitzVersion $sprocPath
                    Uptime      = Get-CafeSqlUptime -SqlInstance $sql -Detail
                    OutputType  = $OutputType
                    Result      = $result
                }
            }

        }
    }
}