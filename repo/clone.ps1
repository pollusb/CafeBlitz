# clone the repo, but keep only relevent stuff

Remove-Item $PSScriptRoot\frk.old -Recurse -Force -ErrorAction SilentlyContinue
Rename-Item $PSScriptRoot\frk frk.old             -ErrorAction SilentlyContinue
git clone https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit.git $PSScriptRoot\frk
Get-ChildItem $PSScriptRoot\frk -Exclude sp_Blitz*.sql -Recurse | Remove-Item -Recurse -Confirm:$false

# get version

$M = Get-Content $PSScriptRoot\frk\sp_Blitz.sql | Select-String "SELECT @Version = '([\d\.]+)', @VersionDate = '(\d+)'"
$content = 'Version {0} Date {1}' -f $M.Matches.Groups[1].Value, [datetime]::ParseExact($M.Matches.Groups[2].Value, 'yyyyMMdd', $null).ToString('yyyy-MM-dd')
$content | Set-Content -Path $PSScriptRoot\frk\version.txt