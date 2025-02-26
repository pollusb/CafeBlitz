function ConvertFrom-DataSet {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [hashtable]$RenameColumn = @{Pattern = '\s+'; With = '' }, # Remove space and tabs in column name by default

        [switch]$TrimValue,

        [string[]]$RenameTable = @('Table1', 'Table2')
    )
    begin {
        $id = 0
    }
    process {
        # TODO: find a way to validate in param
        if ($InputObject.GetType().Name -ne 'DataSet') {
            throw 'InputObject needs to be System.Data.DataSet'
        }
        $PSObject = [PSCustomObject]@{
            NbTables = $InputObject.Tables.Count
        }
        foreach ($table in $InputObject.Tables) {
            if ($RenameTable) {
                $PSObject | Add-Member $RenameTable[$id] (ConvertFrom-DataRows $table)
            }
            else {
                $PSObject | Add-Member "Table$id" (ConvertFrom-DataRows $table) # Table1, Table2, etc.
            }
            $id++
        }
        $PSObject
    }
}