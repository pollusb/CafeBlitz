function Invoke-BlitzIndex2Excel {
    param (
        $ds,
        $ExcelPath
    )
    $tbl0 = $ds.Tables[0] | ConvertFrom-DataRows

    $tbl1 = $ds.Tables[1] | ConvertFrom-DataRows
    $row1 = $tbl0.Count + 2
    $tbl2 = $ds.Tables[2] | ConvertFrom-DataRows
    $row2 = $tbl1.Count + $row1 + 2

    $xlPkg =  $tbl0 `
    | Export-Excel -path $ExcelPath     -WorkSheetname FileInfo -StartRow 1 -TableName Table1  -PassThru -TableStyle Medium1
    $xlPkg = $tbl1 `
    | Export-Excel -ExcelPackage $xlPkg -WorkSheetname FileInfo -StartRow $row1 -TableName Table2 -PassThru  -TableStyle Light2
    $xlPkg = $tbl2 `
    | Export-Excel -ExcelPackage $xlPkg -WorkSheetname FileInfo -StartRow $row2 -TableName Table3 -PassThru -AutoSize
    $xlPkg.Save()
}