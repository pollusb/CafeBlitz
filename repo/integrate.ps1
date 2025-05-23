# this code will integrate FRK code into the project
# TODO: should force a new branch ?

# pseudocode
# foreach script file from our integration
# if new param then manual validation
# transform header then save file in CafeBlitz\tsql

#region sp_Blitz
$name = 'sp_Blitz'
$path = "$PSScriptRoot\frk\$name.sql"
$dest = Resolve-Path "$PSScriptRoot\..\CafeBlitz\tsql"
$temp = "$dest\$name.temp.sql"
$param = "$dest\$name.param.sql"
if (Test-Path $path) {
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"
    $pattern = "(?s)IF OBJECT_ID.*ALTER PROCEDURE \[dbo\]\.\[$name\]"
    $with = "CREATE PROCEDURE [dbo].[#$name]"
    if ($code -match $pattern) {
        $code -replace $pattern, $with | Out-File -FilePath $temp -Encoding utf8
        $notes = "code --diff '$path' '$temp'"
        $status = 'Success'
    }
    else {
        $status = 'Fail'
    }
    $pattern = '(?s)ALTER PROCEDURE \w+\.\w+\s+(.*)WITH RECOMPILE\s+AS'
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    }
    [PSCustomObject]@{
        Name      = $name
        Status    = $status
        PathTemp  = $temp
        PathParem = $param
        Notes     = $notes
    }
}
#endregion

#region sp_BlitzCache
$name = 'sp_BlitzCache'
$path = "$PSScriptRoot\frk\$name.sql"
$dest = Resolve-Path "$PSScriptRoot\..\CafeBlitz\tsql"
$temp = "$dest\$name.temp.sql"
if (Test-Path $path) {
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"
    $pattern = "(?s)PROCEDURE \[*dbo\]*\.\[*$name\]*"
    $with = "PROCEDURE [dbo].[#$name]"
    if ($code -match $pattern) {
        $code -replace $pattern, $with | Out-File -FilePath $temp -Encoding utf8
        $notes = "code --diff '$path' '$temp'"
        $status = 'Success'
    }
    else {
        $status = 'Fail'
    }
    [PSCustomObject]@{
        Name   = $name
        Status = $status
        Notes  = $notes
    }
    $pattern = '(?s)ALTER PROCEDURE \w+\.\w+\s+(.*)WITH RECOMPILE\s+AS'
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    }
    [PSCustomObject]@{
        Name      = $name
        Status    = $status
        PathTemp  = $temp
        PathParem = $param
        Notes     = $notes
    }
}
#endregion

#region sp_BlitzIndex
$name = 'sp_BlitzIndex'
$path = "$PSScriptRoot\frk\$name.sql"
$dest = Resolve-Path "$PSScriptRoot\..\CafeBlitz\tsql"
$temp = "$dest\$name.temp.sql"
if (Test-Path $path) {
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"
    $pattern = "(?s)PROCEDURE \[*dbo\]*\.\[*$name\]*"
    $with = "PROCEDURE [dbo].[#$name]"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, $with
        $code = $code -replace 'OBJECT_ID(''dbo.sp_BlitzIndex'')','OBJECT_ID(''tempdb.dbo.#sp_BlitzIndex'')'
        $code | Out-File -FilePath $temp -Encoding utf8
        $notes = "code --diff '$path' '$temp'"
        $status = 'Success'
    }
    else {
        $status = 'Fail'
        #[PSCustomObject]@{
        #    Name   = $name
        #    Status = $status
        #    Notes  = $notes
        #}
    }

    $pattern = '(?s)ALTER PROCEDURE \w+\.\w+\s+(.*)WITH RECOMPILE\s+AS'
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    }
    [PSCustomObject]@{
        Name      = $name
        Status    = $status
        PathTemp  = $temp
        PathParam = $param
        Notes     = $notes
    }
}
#endregion
