function Get-CafeSqlUptime {
    # Faster return of SqlServer uptime than Get-DbaUptime
    param (
        $SqlInstance,
        $End = (Get-Date),
        [switch]$Detail
    )
    $query = "SELECT sqlserver_start_time FROM sys.dm_os_sys_info;"
    $start = Invoke-DbaQuery -SqlInstance $SqlInstance -Query $query -as SingleValue
    if ($Detail) {
        New-TimeSpan -Start $start -End $End
    } else {
        '{0:n2} days' -f (New-TimeSpan -Start $start -End $End).TotalDays
    }
}