function ConvertFrom-DataSet {
    <#
    .SYNOPSIS
        Convert DataSet to PSCustomObject and rename columns
    .DESCRIPTION
        Blitz procedures often return multiple recordsets with column names with spaces between words and special characters. They are nice to work with in SSMS but less nice with code. This function will remove spaces and special characters from column names
    .NOTES
        Works also with Deserialized.System.Management.Automation.PSCustomObject which is the return object from Import-CliXml.
        There is no type validation on InputObject
        Verbose will return InputObject stats
    #>
    [CmdLetBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Data.DataSet]$InputObject,

        # Remove space and ':*' from column name by default
        [hashtable]$RenameColumn = @{Replace = '\s|:.*'; With = ''},

        [switch]$TrimValue
    )
    begin {
        Write-Verbose ($MyInvocation.MyCommand.Name + ' start')
    }
    process {
        $object = [PSCustomObject]@{}
        $splat = @{
            RenameColumn = $RenameColumn
            TrimValue = $TrimValue
        }

        foreach ($tbl in $InputObject.Tables) {
            #Write-Verbose ('{0} (Rows = {1}, Columns = {2})' -f $tbl.TableName, $tbl.Rows.Count, $tbl.Columns.Count)
            $rows = ConvertFrom-DataRows -InputObject $tbl.Rows @splat
            $object | Add-Member -Name $tbl.TableName -Value $rows -MemberType NoteProperty
        }
        $object
    }
    end {
        Write-Verbose ($MyInvocation.MyCommand.Name + ' end')
    }
}