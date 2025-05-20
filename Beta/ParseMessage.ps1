function ParseMessage {
    <#
        Retourne un objet qui devrait ressembler à ceci en mode table:

        ElapsedMs LogicalReads PhysicalReads ReadAhead
        --------- ------------ ------------- ---------
               96           19             1         0
    #>
    param (
        #[Parameter(Mandatory)]
        [string]$Path,
        $Message
    )
    $msg = if ($Path) {
        Get-Content -Path $Path -Raw
    } else {
        $Message
    }

    $elapsed = $msg|Select-String -Pattern 'elapsed time = (\d+) ms' -AllMatches
    foreach ($match in $elapsed.Matches) {
        $elapsedMs += [int]$match.Groups[1].Value
    }

    $logical = $msg|Select-String -Pattern 'logical reads (\d+)' -AllMatches
    foreach ($match in $logical.Matches) {
        $logicalRead += [int]$match.Groups[1].Value
    }

    $physical = $msg|Select-String -Pattern 'physical reads (\d+)' -AllMatches
    foreach ($match in $physical.Matches) {
        $physicalRead += [int]$match.Groups[1].Value
    }

    $readAhead = $msg|Select-String -Pattern 'read-ahead reads (\d+)' -AllMatches
    foreach ($match in $readAhead.Matches) {
        $readAheadRead += [int]$match.Groups[1].Value
    }

    [PSCustomObject]@{
        ElapsedMs = $elapsedMs
        LogicalReads = $logicalRead
        PhysicalReads = $physicalRead
        ReadAhead = $readAheadRead
    }
}