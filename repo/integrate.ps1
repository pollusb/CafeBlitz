# this code will integrate FRK code into the project
# TODO: should force a new branch ?

# pseudocode
# foreach script file from our integration
# if new param then manual validation
# transform header then save file in CafeBlitz\tsql

# sp_Blitz
# $name = 'sp_Blitz'
# $path = "$PSScriptRoot\frk\$name.sql"
# $dest = Resolve-Path "$PSScriptRoot\..\public\tsql\$name.temp.sql"
# if (Test-Path $path) {
#     $code = Get-Content -Path $path -Raw
#     $pattern = "(?s)IF OBJECT_ID.*ALTER PROCEDURE \[dbo\]\.\[$name\]"
#     if ($code -match $pattern) {
#         $code = $code -replace $pattern, "-- CafeBlitz integration`r`n`r`nCREATE PROCEDURE [dbo].[#$name]"
#         $code | Set-Content -Path $dest
#     }
#     else {
#         Write-Warning "$name source code was not modified.`ncode --diff '$path' '$dest'"
#     }

#     $dest
# }

# sp_BlitzCache
$name = 'sp_BlitzCache'
$path = "$PSScriptRoot\frk\$name.sql"
$dest = Resolve-Path "$PSScriptRoot\..\public\tsql\$name.temp.sql"
if (Test-Path $path) {
    $code = Get-Content -Path $path -Raw
    $pattern = "(?s)CREATE PROCEDURE \[*dbo\]*\.\[*$name\]*"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, "CREATE PROCEDURE [dbo].[#$name]" # ICI
        $code | Out-File -Path $dest
    }
    else {
        Write-Warning "$name source code was not modified.`ncode --diff '$path' '$dest'"
    }

    $dest
}
