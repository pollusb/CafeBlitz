<#  STEP 3
    Use when a new First Responder Kit revision is made available
    This script will help compare files to reveal where code modifications needs to be done
#>
param (
    $tool = 'code --diff'
)
Push-Location $PSScriptRoot # We should be at top level (CafeBlitz.git)

# code --diff .\frk\sp_Blitz.param.sql .\frk.old\sp_Blitz.param.sql
Get-ChildItem .\frk\*.param.sql | ForEach-Object {
    Write-Host ('{0} ".\frk\{1}" ".\frk.old\{1}"' -f $tool, $_.Name)
}

Pop-Location