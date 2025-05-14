function ConvertFrom-DataRows {
    <#
    .SYNOPSIS
        Convert DataRow to PSCustomObject and rename columns
    .DESCRIPTION
        Blitz procedure return column names with spaces between words and special characters. They are nice to work with in SSMS but less nice with code. This function will remove spaces from names by default
    .NOTES
        Works also with Deserialized.System.Management.Automation.PSCustomObject which is the return object from Import-CliXml.
        There is no type validation on InputObject
        Verbose will return InputObject stats
    #>
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        # Remove space and tabs in column name by default
        [hashtable]$RenameColumn = @{Replace = '\s+'; With = '' },

        # Remove trailing spaces in string values in both begin and end
        [switch]$TrimValue
    )
    begin {
        [int]$rows = 0
        [int]$cols = 0
        [boolean]$isUsingPipe = -not $PSBoundParameters['InputObject']
        $properties = New-Object System.Collections.Specialized.OrderedDictionary
        $timer = [Diagnostics.Stopwatch]::StartNew()
    }
    process {
        if ($InputObject[0] -is [PSCustomObject]) {
            # Deserialized.System.Management.Automation.PSCustomObject
            $inputType = '[System.Management.Automation.PSCustomObject]'
            foreach ($row in $InputObject) {
                $rows++
                $properties.Clear()
                foreach ($property in $row.psobject.properties) {
                    $cols++
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
        elseif ($InputObject[0] -is [System.Data.DataRow] -or $isUsingPipe) {
            #"IsDataRow : $($InputObject[0] -is [System.Data.DataRow])" | Write-Verbose
            $inputType = if ($isUsingPipe) { '[Unknown type]' } else { '[System.Data.DataRow]' }
            foreach ($row in $InputObject) {
                $rows++
                $properties.Clear()
                foreach ($property in $row.PSAdapted.PSObject.Properties) {
                    $cols++
                    # get value before changing column name
                    if ($property.Value -is [System.DBNull]) {
                        $value = $null
                    }
                    else {
                        $value = $property.Value
                    }

                    $propName = $property.Name
                    if ($RenameColumn) {
                        $propName = $propName -replace $RenameColumn['Replace'], $RenameColumn['With']
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
        else {
            $inputType = '[{0}]' -f $InputObject[0].GetType().Name
        }
    }
    end {
        $timer.Stop()
        '{0}, {1} rows, {2} prop, {3}, {4}' -f $timer.Elapsed.ToString(), $rows, $cols, $inputType, ("$(if(!$isUsingPipe){'not '})using pipe") | Write-Verbose
    }
}
