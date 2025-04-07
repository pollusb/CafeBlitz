function ConvertFrom-DataSet {
    # Needs ConvretFrom-DataRow
    # Convert DataSet to PSCustomObject
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        # Remove space and ':*' from column name by default
        [hashtable]$RenameColumn = @{Replace = '\s|:.*'; With = ''},

        [switch]$TrimValue
    )
    process {
        $object = [PSCustomObject]@{}
        $splat = @{ RenameColumn = $RenameColumn; TrimValue = $TrimValue}
        Write-Verbose $MyInvocation.MyCommand.Name
        foreach ($tbl in $InputObject.Tables) {
            Write-Verbose ('{0} (Rows = {1}, Columns = {2})' -f $tbl.TableName, $tbl.Rows.Count, $tbl.Columns.Count)
            $rows = $tbl.Rows | ConvertFrom-DataRows @splat
            $object | Add-Member -Name $tbl.TableName -Value $rows -MemberType NoteProperty
        }
        $object
    }
}