[CmdLetBinding()]
param (
    [Parameter(Mandatory)]
    $SqlInstance,

    [int]$SkipTest = 0
)
$ErrorActionPreference = 'Stop'
$Verbose = $PSBoundParameters['Verbose']
$header = @{ForegroundColor = 'Green'}
$info = @{ForegroundColor = 'DarkGray'}

Import-Module $PSScriptRoot\..\CafeBlitz.psd1 -Force -Verbose:$false
Write-Verbose "CafeBlitz.psd1 reloaded"
if ($SkipTest) { Write-Host "Skipping first $SkipTest tests." @info}

if ($SkipTest -lt 1 -or $SkipTest -eq 0) {
    Write-Host "01. Testing the simple call with GetAllDatabases" @header
    $obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -GetAllDatabases
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

if ($SkipTest -lt 2 -or $SkipTest -eq 0) {
    Write-Host "02. Testing with 2 resultsets?" @header
    $obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputProcedureCache
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

if ($SkipTest -lt 3 -or $SkipTest -eq 0) {
    Write-Host "03. Testing with XML output" @header
    $obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputType XML
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}
