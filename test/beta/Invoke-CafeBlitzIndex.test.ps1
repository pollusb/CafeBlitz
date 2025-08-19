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

$id = 1; $name = 'Testing the simple call with GetAllDatabase' -f $id
if (($SkipTest -lt $id -and $SkipTest -ne 0) -or $FilterTest -contains $id) {
    Write-Host ('{0:d2} {1}' -f $id, $name) @header
    $obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -GetAllDatabases
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}
return
$id = 2; $name = 'Testing with 2 resultsets?'
if (($SkipTest -lt $id -and $SkipTest -ne 0) -or $FilterTest -contains $id) {
    Write-Host ('{0:d2} {1}' -f $id, $name) @header
    #$obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputProcedureCache
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

$id = 3; $name = "{0:d2}. Testing with XML output" -f $id
if (($SkipTest -lt $id -and $SkipTest -ne 0) -or $FilterTest -contains $id) {
    Write-Host ('{0:d2} {1}' -f $id, $name) @header
    #$obj = Invoke-CafeBlitzIndex -SqlInstance $SqlInstance -Verbose:$Verbose -OutputType XML
    Write-Host ('{0} lines in result' -f $obj.Result.Count) @info
}

if ($PassThru) { $obj } # does not make sense