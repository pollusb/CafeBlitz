<#  STEP 2
    Use when a new First Responder Kit revision is made available
    This script will integrate FRK code into the CafeBlitz Module project as temp sproc
    It keep the old version in frk.old to be able to compare code and parameters
    TODO: should force a new branch ?
#>
[CmdLetBinding()]
param (
    # Location of TEMP sproc
    $dest = (Resolve-Path "$PSScriptRoot\..\CafeBlitz\tsql" -RelativeBasePath $PSScriptRoot -Relative),
    # Location of repo files and sproc PARAM
    $frk = (Resolve-Path "$PSScriptRoot\frk" -RelativeBasePath $PSScriptRoot -Relative)
)

#region sp_Blitz

$spname = 'sp_Blitz'
$path = "$frk\$spname.sql"
$temp = "$dest\$spname.temp.sql"
$param = "$frk\$spname.param.sql"

if (Test-Path $path) {
    # create the temp version of the sproc
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"
    $pattern = "(?s)IF OBJECT_ID.*ALTER PROCEDURE \[dbo\]\.\[$spname\]"
    $with = "CREATE PROCEDURE [dbo].[#$spname]"
    if ($code -match $pattern) {
        $code -replace $pattern, $with | Out-File -FilePath $temp -Encoding utf8
    } else {
        Write-Warning "$spname - create the temp version of the sproc"
    }

    # create the parameter list file
    $pattern = "(?s)ALTER PROCEDURE \[dbo\]\.\[$spname\]\s+(.*)WITH RECOMPILE\s+AS"
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    } else {
        Write-Warning "$spname - create the parameter list file"
    }
    [PSCustomObject]@{
        Name      = $spname
        PathTemp  = $temp
        PathParam = $param
    }
}

#endregion

#region sp_BlitzCache

$spname = 'sp_BlitzCache'
$path = "$frk\$spname.sql"
$temp = "$dest\$spname.temp.sql"
$param = "$frk\$spname.param.sql"
if (Test-Path $path) {
    # create the temp version of the sproc
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"

    # change the sproc name
    $pattern = "(?s)PROCEDURE \[*dbo\]*\.\[*$spname\]*"
    $with = "PROCEDURE [dbo].[#$spname]"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, $with
    } else {
        Write-Warning "$spname - change the sproc name"
    }

    # remove global temp table drop condition
    $pattern = "(?m)OBJECT_ID\('dbo\.$spname'\) IS NOT NULL AND "
    if ($code -match $pattern) {
        $code = $code -replace $pattern,''
    } else {
        Write-Warning "$spname - remove global temp table drop condition"
    }
    $code | Out-File -FilePath $temp -Encoding utf8

    # create the parameter list file
    $pattern = '(?s)ALTER PROCEDURE \w+\.\w+\s+(.*)WITH RECOMPILE\s+AS'
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    } else {
        Write-Warning "$spname - create the parameter list file"
    }
    [PSCustomObject]@{
        Name      = $spname
        PathTemp  = $temp
        PathParam = $param
    }
}

#endregion

#region sp_BlitzIndex

$spname = 'sp_BlitzIndex'
$path = "$frk\$spname.sql"
$temp = "$dest\$spname.temp.sql"
$param = "$frk\$spname.param.sql"
if (Test-Path $path) {
    # create the temp version of the sproc
    $code = "-- CafeBlitz integration`r`n`r`n$(Get-Content -Path $path -Raw)"
    $pattern = "(?s)PROCEDURE \[*dbo\]*\.\[*$spname\]*"
    $with = "PROCEDURE [dbo].[#$spname]"
    if ($code -match $pattern) {
        $code = $code -replace $pattern, $with
        $code = $code -replace 'OBJECT_ID(''dbo.sp_BlitzIndex'')', 'OBJECT_ID(''tempdb.dbo.#sp_BlitzIndex'')'
        $code | Out-File -FilePath $temp -Encoding utf8
    } else {
        Write-Warning "$spname - create the temp version of the sproc"
    }

    # create the parameter list file
    $pattern = "(?s)ALTER PROCEDURE \[*dbo\]*\.\[*$spname\]*(.*)WITH RECOMPILE\s+AS"
    $code = Get-Content -Path $path -Raw
    if ($code -match $pattern) {
        $Matches[1] -split "`r`n" -replace '^\s+' | Out-File -FilePath $param -Encoding utf8
    } else {
        Write-Warning "$spname - create the parameter list file"
        Write-Verbose $pattern
    }
    [PSCustomObject]@{
        Name      = $spname
        PathTemp  = $temp
        PathParam = $param
    }
}

#endregion
