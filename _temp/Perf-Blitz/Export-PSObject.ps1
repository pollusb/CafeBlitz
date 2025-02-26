function Export-PSObject {
    # Convertir un objet DataSet en PSCustomObject et renommer les propriétés lorsque nécessaire
    # copié dans CafeSql
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        $DataSet,

        # Supprimer les blancs au début et à la fin des valeurs
        [switch]$TrimValue,

        # Pour remplacer les caractères invalides dans les noms de propriétés avec RegEx
        [hashtable]$RenamePattern = @{Replace='\s|:.+';With=''}
    )
    function ConvertTable {
        # https://forums.powershell.org/t/dealing-with-dbnull/2328/2
        param (
            $Table
        )
        $properties = New-Object System.Collections.Specialized.OrderedDictionary
        foreach ($row in $table.Rows) {
            $properties.Clear()
            foreach ($property in $row.PSAdapted.PSObject.Properties) {
                if ($property.Value -is [System.DBNull]) {
                    $value = $null
                }
                else {
                    $value = $property.Value
                }
                $propName = $property.Name
                if ($RenamePattern) {
                    $propName -replace $RenamePattern['Replace'], $RenamePattern['With']
                }

                if ($TrimValue -and $value -is [string]) {
                    $properties[$propName] = $value.Trim()
                } else {
                    $properties[$propName] = $value
                }
            }
            [PSCustomObject]$properties
        }
    }

    $PSObject = [PSCustomObject]@{
        NbTables = $DataSet.Tables.Count
    }
    $id = 0
    foreach ($table in $DataSet.Tables) {
        Write-Verbose "Table$id NbRow = $($table.Rows.Count), NbColumns = $($table.Columns.Count)"
        $PSObject | Add-Member "Table$id" (ConvertTable $table) # Table0, Table1, etc.
        $id++
    }
    $PSObject
}