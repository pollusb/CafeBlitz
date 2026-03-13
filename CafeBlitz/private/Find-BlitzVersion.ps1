function Find-BlitzVersion {
    # Extract version from Blitz source script/code/GitHub
    param (
        $Path,
        $Code,
        [switch]$LatestFromGitHub
    )
    if ($Path -xor $Code -xor $LatestFromGitHub) {
        $Source = if ($LatestFromGitHub) {
            $Code = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/refs/heads/main/sp_Blitz.sql').RawContent
            'Latest from GitHub'
        }
        elseif ($Path -like 'https*') {
            $Code = (Invoke-WebRequest -Uri $Path).RawContent
            $Path
        }
        elseif ((-not $Code) -and (Test-Path $Path)) {
            $Code = Get-Content -Path $Path -Raw
            $Path
        }
        else {
            $Code
        }
        $pattern = "SELECT @Version = '([\d\.]+)', @VersionDate = '(\d+)';"
        $code.Count
        $M = $code | Select-String -Pattern $pattern
        if (!$M) { throw 'Pattern was not found' }
        [PSCustomObject]@{
            Version = [version]$M.Matches.Groups[1].Value
            Date    = [datetime]$M.Matches.Groups[2].Value.Insert(4, '-').Insert(7, '-')
            Source  = $Source
        }
        # 'Version {0} Date {1}' -f $M.Matches.Groups[1].Value, $M.Matches.Groups[2].Value.Insert(4, '-').Insert(7, '-')
    }
    else {
        throw 'You need to provide only one parameter -Path, -Code or -LatestFromGitHub'
    }
}