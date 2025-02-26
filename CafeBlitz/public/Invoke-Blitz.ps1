<#
.SYNOPSIS
    Wrapper for sp_Blitz
.DESCRIPTION

.NOTES
    1. Parameters that are true by default are renamed DoNot*. As an example, @CheckUserDatabaseObjects = 1 by default. To disable, use the switch -DoNotCheckUserDatabaseObjects.
    2. Some parameters are ignored like @Help
    3. -Verbose option will generate the EXEC string with all parameters
#>
function Invoke-CafBlitz {
    [CmdLetBinding()]
    param (
        $SqlInstance,

        # This parameter will also change the output of the function
        [ValidateSet('TABLE', 'COUNT', 'MARKDOWN', 'SCHEMA', 'XML', 'NONE')]
        [string]$OutputType = 'TABLE',

        # We output a second result set that includes the queries, plans, and metrics we analyzed. You can do your own analysis on these queries too looking for more problems.
        [switch]$OutputProcedureCache,

        # We review the user databases looking for things like heaps and untrusted foreign keys.
        # If your databases have more than a few thousand objects, this may require additional processing time.
        # The original name is @CheckUserDatabaseObjects and is true by default.
        [switch]$DoNotCheckUserDatabaseObjects,

        # We grab the top 20-50 resource-intensive plans from the cache and analyze them for common design issues.
        # We're looking for missing indexes, implicit conversions, user-defined functions, and more.
        # This fast scan isn't incredibly detailed we're just looking for queries that might surprise you and require some performance tuning.
        [switch]$CheckProcedureCache,

        # Can be CPU, Reads, Duration, ExecCount, or null. If you specify one, we'll focus the analysis on those types of resource-intensive queries (like the top 20 by CPU use.) If you don't, we analyze the top 20 for all four (CPU, logical reads, total runtime, and execution count). Typically we find that it's not 80 different queries it's usually 25-40 queries that dominate all of the metrics.
        # CPU, Reads, Duration, ExecCount
        [ValidateSet('CPU', 'Reads', 'Duration', 'ExecCount')]
        [string]$CheckProcedureCacheFilter, # VARCHAR(10) = NULL

        # We output things like the SQL Server version, whether it's a virtual machine, how much memory it has, and more. This output is at the bottom of the results as a low priority. We don't check this by default because most users are just interested in returning the problems, not the information, but if you're using sp_Blitz to gather server inventory data, this helps.
        [switch]$CheckServerInfo,

        # This does NOT mean to skip checks for a particular server or database. It's much trickier and more powerful than that. If all of these are set, we look for a table with this name. The table needs to have the fields ServerName NVARCHAR(128), DatabaseName NVARCHAR(128), and CheckID INT. We review the contents of that table, and then we'll skip (or not output) the checks you specify
        [string]$SkipChecksServer, # NVARCHAR(256) = NULL
        [string]$SkipChecksDatabase, # NVARCHAR(256) = NULL
        [string]$SkipChecksSchema, # NVARCHAR(256) = NULL
        [string]$SkipChecksTable, # NVARCHAR(256) = NULL

        # If you're not interested in the low-priority checks, you can pass in @IgnorePrioritiesAbove = 100 (or any other number). sp_Blitz's output will exclude all items with a priority > 100.
        [int16]$IgnorePrioritiesBelow, # INT = NULL

        # If you don't care about your pants being on fire, you can set @IgnorePrioritiesAbove = 50, and you'll be blissfully unaware of your failing database backup jobs.
        [int16]$IgnorePrioritiesAbove, # INT = NULL

        [string]$OutputServerName, # NVARCHAR(256) = NULL
        [string]$OutputDatabaseName, # NVARCHAR(256) = NULL
        [string]$OutputSchemaName, # NVARCHAR(256) = NULL
        [string]$OutputTableName, # NVARCHAR(256) = NULL
        [switch]$OutputXMLasNVARCHAR,

        [string[]]$EmailRecipients, # VARCHAR(MAX) = NULL

        [string]$EmailProfile, # SYSNAME = NULL

        # We only return one row per distinct FindingsGroup and Finding and Priority combo, so if you have a thousand triggers or a dozen corrupt databases, we will only show the first one, plus a count of them in the Findings column.
        [switch]$SummaryMode,

        [switch]$BringThePain,

        [string]$UsualDBOwner, # SYSNAME = NULL

        [switch]$DoNotSkipBlockingChecks, # Original: SkipBlockingChecks

        #[switch]$Debug1,
        #$Version     VARCHAR(30) = NULL OUTPUT,
        #$VersionDate DATETIME = NULL OUTPUT,

        [switch]$VersionCheckMode               # BIT = 0
    )
    # Building EXEC command using PSBoundParameters

    $param += foreach ($bp in $PSBoundParameters.GetEnumerator()) {
        if ($bp.Key -like 'DoNot*') {
            # Notes #1
            "@{0} = 0" -f ($bp.Key -replace '^DoNot')
        }
        elseif ($bp.Value -eq $true) {
            "@{0} = 1" -f $bp.Key
        }
        elseif ($bp.Key -eq 'OutputType') {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
        }
        elseif ($bp.Key -like 'SkipCheck*') {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
        }
        elseif ($bp.Key -in 'Verbose','SqlInstance') {

        }
        else {
            "@{0} = '{1}'" -f $bp.Key, $bp.Value
        }
    }
    $queryExec = "EXEC #sp_Blitz`n" + ($param -join ",`n")
    Write-Verbose $queryExec
    if ($PSBoundParameters['Verbose']) {
        return
    }

    foreach ($sql in $SqlInstance) {
        # Connect NonPooledConnection
        $smo = Connect-DbaInstance -SqlInstance $sql -DisableException -TrustServerCertificate -NonPooledConnection
        if ($smo) {
            # Create temp stored procedure
            Invoke-DbaQuery -SqlInstance $smo -File "$PSScriptRoot\tsql\sp_Blitz.temp.sql"

            # Execute temp stored procedure
            $result = switch ($OutputType) {
                'TABLE' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec -As PSObjectArray }
                'COUNT' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec -As SingleValue }
                'MARKDOWN' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec -As SingleValue }
                'SCHEMA' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec -As SingleValue }
                'XML' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec -As SingleValue }
                'NONE' { Invoke-DbaQuery -SqlInstance $smo -Query $queryExec }
            }
            [PSCustomObject]@{
                SqlInstance = $sql
                Date        = Get-Date
                OutputType  = $OutputType
                Result      = $result
            }
        }
    }
}