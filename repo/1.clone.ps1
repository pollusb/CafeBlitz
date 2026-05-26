<#  STEP 1
    Use when a new First Responder Kit revision is made available
    This script will clone repo in frk, but keep only relevent stuff
    keep the old version in frk.old to be able to compare
#>
param (
    [ValidateScript({Test-Path $_})]
    $fbv = "$PSScriptRoot\..\CafeBlitz\private\Find-BlitzVersion.ps1"
)
# Mount private function
. $fbv # NOTE: should do that for all private functions

$verNew = Find-BlitzVersion -LatestFromGitHub
if (Test-Path $PSScriptRoot\frk\sp_Blitz.sql) {
    $verActual = Find-BlitzVersion -Path $PSScriptRoot\frk\sp_Blitz.sql
    Write-Host ("New version = {0}, Actual = {1}" -f $verNew.Version, $verActual.Version)
} else {
    Write-Host ("New version = {0}, could not find old one" -f $verNew.Version)
}
pause
if ($verNew.Version -gt $verActual.Version) {
    if (Test-Path $PSScriptRoot\frk.old) {
        Remove-Item $PSScriptRoot\frk.old -Recurse -Force -ErrorAction SilentlyContinue
        Rename-Item $PSScriptRoot\frk frk.old             -ErrorAction SilentlyContinue
    }

    git clone 'https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit.git' $PSScriptRoot\frk
    Push-Location $PSScriptRoot\frk # NOTE: should do that without changing location
    git switch main
    Pop-Location
    Get-ChildItem $PSScriptRoot\frk -Exclude sp_Blitz*.sql -Recurse | Remove-Item -Recurse -Confirm:$false
    Remove-Item $PSScriptRoot\frk\.git -Force -Recurse -Confirm:$false

    # write version in text file
    $content = 'Version {0} Date {1}' -f $verNew.Version.ToString(), $verNew.Date.ToString('yyyy-MM-dd')
    $content | Set-Content -Path $PSScriptRoot\frk\version.txt
}
else {
    Write-Warning 'Actual version does not need to be updated'
}
