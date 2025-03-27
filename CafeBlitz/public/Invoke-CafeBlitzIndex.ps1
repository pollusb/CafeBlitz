<#
.SYNOPSIS
    Wrapper for sp_BlitzIndex
.DESCRIPTION

.NOTES
    #1. Parameters that are true by default are renamed DoNot*. As an example, @SkipStatistics = 1 by default. To disable, you need to use the switch -DoNotCheckUserDatabaseObjects.
    #2. Some parameters are ignored like @Help or @Debug
    #3. -Verbose option will generate the EXEC string with all parameters
#>
function Invoke-CafeBlitzIndex {
    [CmdLetBinding()]
    param (
        $SqlInstance, # You can provide a list

        [string]$DatabaseName, # @DatabaseName NVARCHAR(128) = NULL, Defaults to current DB if not specified
        [string]$SchemaName, # @SchemaName NVARCHAR(128) = NULL, Requires table_name as well.
        [string]$TableName, # @TableName NVARCHAR(128) = NULL, Requires schema_name as well.

        [ValidateRange(0, 4)] # @Mode doesn't matter if you're specifying schema_name and @TableName
        [byte]$Mode = 0, # @Mode TINYINT=0, 0=Diagnose, 1=Summarize, 2=Index Usage Detail, 3=Missing Index Detail, 4=Diagnose Details

        [ValidateRange(0, 2)] # @Filter doesn't do anything unless @Mode=0
        [byte]$Filter = 0, # @Filter TINYINT = 0, 0=no filter (default). 1=No low-usage warnings for objects with 0 reads. 2=Only warn for objects >= 500MB

        [switch]$SkipPartitions, # @SkipPartitions BIT = 0
        [switch]$DoNotSkipStatistics, # @SkipStatistics BIT = 1
        [switch]$GetAllDatabases, # @GetAllDatabases BIT = 0
        [switch]$ShowColumnstoreOnly, # @ShowColumnstoreOnly BIT = 0, Will show only the Row Group and Segment details for a table with a columnstore index.
        [switch]$BringThePain, # @BringThePain BIT = 0
        [int]$ThresholdMB = 250, # @ThresholdMB INT = 250 Number of megabytes that an object must be before we include it in basic results
        [string]$IgnoreDatabases, # @IgnoreDatabases NVARCHAR(MAX) = NULL, Comma-delimited list of databases you want to skip

        # This parameter will also change the output of the function
        [ValidateSet('TABLE', 'NONE')]
        [string]$OutputType = 'TABLE',

        [string]$OutputServerName, # NVARCHAR(256) = NULL
        [string]$OutputDatabaseName, # NVARCHAR(256) = NULL
        [string]$OutputSchemaName, # NVARCHAR(256) = NULL
        [string]$OutputTableName, # NVARCHAR(256) = NULL

        [switch]$IncludeInactiveIndexes, # @IncludeInactiveIndexes BIT = 0, Will skip indexes with no reads or writes
        [switch]$ShowAllMissingIndexRequests, # @ShowAllMissingIndexRequests BIT = 0, Will make all missing index requests show up
        [switch]$ShowPartitionRanges, # @ShowPartitionRanges BIT = 0, Will add partition range values column to columnstore visualization
        [string]$SortOrder, # @SortOrder NVARCHAR(50) = NULL, Only affects @Mode = 2.
        [string]$SortDirection, # @SortDirection NVARCHAR(4) = 'DESC', Only affects @Mode = 2.
        [switch]$DoNotRenameColumns # By default, property names will be renamed to remove space and special characters.

        # @Help TINYINT = 0
        # @Debug BIT = 0
        # @Version VARCHAR(30) = NULL
        # @VersionDate DATETIME = NULL
        # @VersionCheckMode BIT = 0
    )
    $sprocPath = (Resolve-Path "$PSScriptRoot\..\tsql\sp_BlitzIndex.temp.sql").Path

    # Building EXEC command using PSBoundParameters
    $ignore = @()
    $param += foreach ($bp in $PSBoundParameters.GetEnumerator()) {
        if ($bp.Key -match 'SqlInstance|Verbose|OutVariable|Debug|ErrorAction|WarningAction|InformationAction|ErrorVariable|WarningVariable|InformationVariable|OutBuffer|PipelineVariable') {
            $ignore += $bp.Key
        }
        elseif ($bp.Key -match 'Output|Ignore|Name|Sort') {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
        }
        elseif ($bp.Key -like 'DoNot*') {
            "@{0} = 0" -f ($bp.Key -replace '^DoNot')
        }
        elseif ($bp.Value -eq $true) {
            "@{0} = 1" -f $bp.Key
        }
        else {
            "@{0} = {1}" -f $bp.Key, $bp.Value
        }
    }
    Write-Verbose "Ignored param ($($ignore -join ','))"
    $query = "EXEC #sp_BlitzIndex`n" + ($param -join ",`n")
    Write-Verbose $sprocPath
    Write-Verbose "Query used:`n$query"

    foreach ($sql in $SqlInstance) {
        # Connect NonPooledConnection
        $smo = Connect-DbaInstance -SqlInstance $sql -DisableException -TrustServerCertificate -NonPooledConnection
        if ($smo) {
            # Create temp stored procedure
            Invoke-DbaQuery -SqlInstance $smo -File $sprocPath

            # Execute temp stored procedure
            $result = switch ($OutputType) {
                'TABLE' { Invoke-DbaQuery -SqlInstance $smo -Query $query -As PSObjectArray }
                'NONE' { Invoke-DbaQuery -SqlInstance $smo -Query $query }
            }

            # TODO: Rename columns with bad caracters
            [PSCustomObject]@{
                SqlInstance = $sql.ToUpper()
                Date        = Get-Date
                Version     = Find-BlitzVersion $sprocPath
                Uptime      = Find-BlitzUptime $result
                OutputType  = $OutputType
                Result      = $result
            }
        }
    }
}