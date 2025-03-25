# this code will integrate FRK code into the project
# TODO: should force a new branch or check that this is not main?

# pseudocode
# foreach script file from our integration
# if new param then manual validation
# transform header then save file in CafeBlitz\tsql

# sp_blitz
$path = "$PSScriptRoot\frk\sp_blitz.sql"
$destTemp = (Get-ChildItem "$PSScriptRoot\..\sp_Blitz.temp.sql" -Recurse).FullName
if (Test-Path $path) {
    $code = Get-Content -Path $path -Raw
    $pattern = "(?s)IF OBJECT_ID.*ALTER PROCEDURE \[dbo\]\.\[sp_Blitz\]"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, "-- CafeBlitz integration`r`n`r`nCREATE PROCEDURE [dbo].[#sp_Blitz]"
        Copy-Item $destTemp "$destTemp.bak" -ErrorAction SilentlyContinue
        $code | Set-Content -Path $destTemp

        # sp_blitz.param
        $destParam = (Get-ChildItem "$PSScriptRoot\..\sp_Blitz.param.sql" -Recurse).FullName
        Copy-Item $destParam "$destParam.bak" -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "sp_blitz source code was not modified because pattern was not found.`ncode --diff '$path' '$destTemp'"
    }
    $destTemp
}
else { throw "$path not found. Was there a problem with the clone or the file was deprecated?" }