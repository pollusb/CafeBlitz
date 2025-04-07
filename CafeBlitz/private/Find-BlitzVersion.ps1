function Find-BlitzVersion {
    # Extract version from Blitz source scripts
    param (
        $Path
    )
    $pattern = "SELECT @Version = '([\d\.]+)', @VersionDate = '(\d+)';"
    $code = Get-Content -Path $Path
    $M = $code | Select-String -Pattern $pattern
    'Version {0} Date {1}' -f $M.Matches.Groups[1].Value, $M.Matches.Groups[2].Value.Insert(4,'-').Insert(7,'-')
}