# this code will integrate FRK code into the project
# TODO: should force a new branch ?

# pseudocode
# foreach script file from our integration
# if new param then manual validation
# transform header then save file in CafeBlitz\tsql


# sp_blitz
$path = "$PSScriptRoot\frk\sp_blitz.sql"
$dest = Resolve-Path "$PSScriptRoot\..\public\tsql\sp_Blitz.temp.sql"
if (Test-Path $path) {
    $code = Get-Content -Path $path -Raw
    $pattern = "(?s)IF OBJECT_ID.*ALTER PROCEDURE \[dbo\]\.\[sp_Blitz\]"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, "-- CafeBlitz integration`r`n`r`nCREATE PROCEDURE [dbo].[#sp_Blitz]"
        $code | Set-Content -Path $dest
    }
    else {
        Write-Warning "sp_blitz source code was not modified.`ncode --diff '$path' '$dest'"
    }

    $dest
}