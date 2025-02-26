foreach ($file in (Get-ChildItem "$PSScriptRoot\private\*.ps1" -Exclude *.dot.ps1 -Recurse)) {
    . $file.FullName
}
foreach ($file in (Get-ChildItem "$PSScriptRoot\public\*.ps1" -Exclude *.dot.ps1 -Recurse)) {
    . $file.FullName
}