function ConvertFrom-DataRows {
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [hashtable]$RenameColumn = @{Pattern = '\s+'; With = '' }, # Remove space and tabs in column name by default

        [switch]$TrimValue
    )
    begin {
        $properties = New-Object System.Collections.Specialized.OrderedDictionary
    }
    process {
        foreach ($row in $InputObject) {
            $properties.Clear()
            foreach ($property in $row.PSAdapted.PSObject.Properties) {
                if ($property.Value -is [System.DBNull]) { $value = $null }
                else { $value = $property.Value }
                $propName = $property.Name
                if ($RenameColumn) {
                    $propName = $propName -replace $RenameColumn['Pattern'], $RenameColumn['With']
                }
                if ($TrimValue -and $value -is [string]) {
                    $properties[$propName] = $value.Trim()
                }
                else {
                    $properties[$propName] = $value
                }
            }
            [PSCustomObject]$properties
        }
    }
}
