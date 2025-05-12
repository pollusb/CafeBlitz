function ConvertFrom-DataRows {
    # Convert DataRow to PSCustomObject
    # Works also with Deserialized.System.Management.Automation.PSCustomObject
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        # Remove space and tabs in column name by default
        [hashtable]$RenameColumn = @{Replace = '\s+'; With = '' },

        [switch]$TrimValue
    )
    begin {
        $properties = New-Object System.Collections.Specialized.OrderedDictionary
        $start = Get-Date
    }
    process {
        if ($InputObject[0] -is [PSCustomObject]) { # Deserialized.System.Management.Automation.PSCustomObject
            $inputType = '[System.Management.Automation.PSCustomObject]'
            foreach ($row in $InputObject) {
                $properties.Clear()
                foreach ($property in $row.psobject.properties) {
                    $propName = $property.Name
                    $propValue = $row.$propName

                    if ($RenameColumn) {
                        $propName = $propName -replace $RenameColumn['Replace'], $RenameColumn['With']
                    }

                    $properties[$propName] = if ($TrimValue -and $propValue -is [string]) {
                        $propValue.Trim()
                    }
                    else {
                        $propValue
                    }
                }
                [PSCustomObject]$properties
            }
        }
        else {
            # TODO: Find how to validate the typename because these 2 does not worked
            #elseif ($InputObject[0] -is [System.Data.DataRow]) {
            #elseif ($InputObject[0].GetType().Name -eq 'DataRow') {
            $inputType = '[System.Data.DataRow]'
            foreach ($row in $InputObject) {
                $hashtable.Clear()
                foreach ($property in $row.PSAdapted.PSObject.Properties) {
                    # get value before changing column name
                    if ($property.Value -is [System.DBNull]) { $value = $null }
                    else { $value = $property.Value }

                    # rename column
                    $propName = $property.Name
                    if ($RenameColumn) {
                        $propName = $propName -replace $RenameColumn['Replace'], $RenameColumn['With']
                    }

                    # set value
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
        #else { throw "InputObject is unrecognizable." }
    }
    end {
        "Input was $inputType" | Write-Verbose
        "Elapse time: $(New-TimeSpan -Start $start -End (get-date).ToString())" | Write-Verbose
    }
}
