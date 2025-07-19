<#
.SYNOPSIS
    Wrapper function for sp_BlitzCache
.DESCRIPTION

.NOTES
    1. Parameters that are true by default are renamed DoNot*. As an example, @SkipStatistics = 1 by default. To disable, you need to use the switch -DoNotSkipStatistics.
    2. Some parameters are ignored like @Help, @Version or @Debug
    3. -Verbose option will generate the EXEC string with all parameters
    4. Some parameters combinaison can't be used. This logic is implemented in the sproc code and will return a warning
    TODO: a parameter to return only 1 table and merge with SqlInstance and columns renamed (they don't need it now)
#>
function Invoke-CafeBlitzCache {
    [CmdLetBinding()]
    param (
        [string[]]$SqlInstance,

        [Alias('Database')]
        [string]$DatabaseName,

        [int]$Top, # INT = NULL (10 by default)

        [ValidateSet('CPU','Reads','Writes','Duration','Executions','Recent Compilations','Memory Grant','Unused Grant','xpm','Spills','Query Hash','Duplicate','Average','Avg','Executions per minute','Executions / minute')]
        [string]$SortOrder, # VARCHAR(50) = 'CPU'

        [switch]$UseTriggersAnyway, # BIT = NULL
        [switch]$ExportToExcel, # BIT = 0
        [switch]$ExpertMode, # TINYINT = 0

        [ValidateSet('TABLE', 'NONE')]
        [string]$OutputType = 'TABLE',

        [string]$OutputServerName, # NVARCHAR(256) = NULL
        [string]$OutputDatabaseName, # NVARCHAR(256) = NULL
        [string]$OutputSchemaName, # NVARCHAR(256) = NULL
        [string]$OutputTableName, # NVARCHAR(256) = NULL

        [string]$ConfigurationDatabaseName, # NVARCHAR(128) = NULL
        [string]$ConfigurationSchemaName, # NVARCHAR(258) = NULL
        [string]$ConfigurationTableName, # NVARCHAR(258) = NULL

        [decimal]$DurationFilter, # DECIMAL(38,4) = NULL
        [switch]$HideSummary, # BIT = 0
        [switch]$DoNotIgnoreSystemDBs, # BIT = 1
        [switch]$DoNotIgnoreReadableReplicaDBs, # BIT = 1

        [string]$OnlyQueryHashes, # VARCHAR(MAX) = NULL
        [string]$IgnoreQueryHashes, # VARCHAR(MAX) = NULL
        [string]$OnlySqlHandles, # VARCHAR(MAX) = NULL
        [string]$IgnoreSqlHandles, # VARCHAR(MAX) = NULL
        [string]$QueryFilter, # VARCHAR(10) = 'ALL'
        [string]$StoredProcName, # NVARCHAR(128) = NULL
        [string]$SlowlySearchPlansFor, # NVARCHAR(4000) = NULL

        [switch]$Reanalyze, # BIT = 0
        [switch]$SkipAnalysis, # BIT = 0
        [switch]$BringThePain, # BIT = 0
        [int]$MinimumExecutionCount, # INT = 0
        $CheckDateOverride, # DATETIMEOFFSET = NULL
        [int]$MinutesBack, # INT = NULL
        [switch]$KeepCRLF, # BIT = 0
        #$Debug, # BIT = 0
        #$Version, #     VARCHAR(30) = NULL OUTPUT
        #$VersionDate, # DATETIME = NULL OUTPUT
        #$VersionCheckMode, # BIT = 0

        [switch]$DoNotRenameColumns, # By default, property names will be renamed to remove space and special characters.
        [switch]$JoinResults # By default, it will return an object for each SqlInstance. Using this will merge the result and append the SqlInstance
    )
    $spname = 'sp_BlitzCache'
    $sprocPath = (Resolve-Path "$PSScriptRoot\..\tsql\$spname.temp.sql").Path

    # Building EXEC command using PSBoundParameters
    $ignore = @()
    $param += foreach ($bp in $PSBoundParameters.GetEnumerator()) {
        if ($bp.Key -match 'DoNotRenameColumns|SqlInstance|Verbose|OutVariable|Debug|ErrorAction|WarningAction|InformationAction|ErrorVariable|WarningVariable|InformationVariable|OutBuffer|PipelineVariable') {
            $ignore += $bp.Key
        }
        elseif ($bp.Key -like 'DoNot*') {
            "@{0} = 0" -f ($bp.Key -replace '^DoNot')
        }
        elseif ($bp.Key -match 'Output|Ignore|Name|Sort') {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
        }
        elseif ($bp.Value -eq $true) {
            "@{0} = 1" -f $bp.Key
        }
        else {
            "@{0} = {1}" -f $bp.Key, $bp.Value
        }
    }
    Write-Verbose "Ignored param ($($ignore -join ','))"
    $query = "EXEC #$spname`n" + ($param -join ",`n")
    Write-Verbose $sprocPath
    Write-Verbose "Query used:`n$query"

    foreach ($sql in $SqlInstance) {
        # NonPooledConnection to reuse connection (to create a temp proc then use it)
        $smo = Connect-DbaInstance -SqlInstance $sql -DisableException -TrustServerCertificate -NonPooledConnection
        if ($smo) {
            # Create temp stored procedure
            $null = Invoke-DbaQuery -SqlInstance $smo -File $sprocPath

            # Execute temp stored procedure
            switch ($OutputType) {
                'TABLE' { $dataset = Invoke-DbaQuery -SqlInstance $smo -Query $query -As DataSet }
                'NONE' { Invoke-DbaQuery -SqlInstance $smo -Query $query -MessagesToOutput | Write-Output ; return } # NOTE: is this the right way?
            }

            # Rename property/column names
            $result = if ($DoNotRenameColumns) {
                ConvertFrom-DataSet -InputObject $dataset -RenameColumn $null
            } else {
                ConvertFrom-DataSet -InputObject $dataset -RenameColumn @{ Replace = '\s+|\?|:.*|\\|#|\/|\(.*'; With = '' }
            }
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