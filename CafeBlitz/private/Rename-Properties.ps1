function Rename-Properties {
    <#
    .SYNOPSIS
        Rename PSObject properties to remove problematic characters
    .NOTES
    #>
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        #[hashtable]$Replace = @{Pattern = '\s+'; With = '' }, # TODO: Configurable Patterns ?

        [switch]$TrimValue # TODO: Remove this or rename the function Rename-PropertiesAndTrimValues
    )
    begin {
        $i = 0
    }
    process {
        $newRow = New-Object System.Collections.Specialized.OrderedDictionary
        foreach ($row in $InputObject) {
            Write-Verbose "Line #$($i++)"
            foreach ($prop in $row.PSObject.Properties) {
                $newName = $prop.Name -replace '\s|:.*|\[|\]|{|}'
                Write-Verbose ('{0} -> {1}' -f $prop.Name, $newName)
                $newRow += @{
                    $newName = if ($TrimValue) {
                        try { $prop.Value.Trim() } catch { $prop.Value }
                    } else { $prop.Value }
                }
            }
            [PSCustomObject]$newRow
            $newRow = New-Object System.Collections.Specialized.OrderedDictionary
        }
    }
}
