[CmdLetBinding()]
param (
    [Parameter(Mandatory)]
    $SqlInstance,


    [int[]]$FilterTest,

    [int]$SkipTest = 0,

    [switch]$PassThru
)
$ErrorActionPreference = 'Stop'
$Verbose = $PSBoundParameters['Verbose']
$header = @{ForegroundColor = 'Green'}
$info = @{ForegroundColor = 'DarkGray'}

Import-Module $PSScriptRoot\..\CafeBlitz.psd1 -Force -Verbose:$false
Write-Verbose "CafeBlitz module reloaded"
if ($SkipTest) { Write-Host "Skipping first $SkipTest tests." @info}
if ($FilterTest) { Write-Host "Filter test. Will run these : $($FilterTest -join ',')" @info}
if (!$SkipTest -and !$FilterTest) {$FilterTest = 1..100}

if (($SkipTest -lt 1 -and $SkipTest -ne 0) -or $FilterTest -contains 1) {
    Write-Host "01. Testing the simple call with GetAllDatabases" @header
    $obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -GetAllDatabases
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}
return
if (($SkipTest -lt 2 -and $SkipTest -ne 0) -or $FilterTest -contains 2) {
    Write-Host "02. Testing with 2 resultsets?" @header
    #$obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputProcedureCache
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

if (($SkipTest -lt 2 -and $SkipTest -ne 0) -or $FilterTest -contains 2) {
    Write-Host "03. Testing with XML output" @header
    #$obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputType XML
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

if ($PassThru) { $obj }