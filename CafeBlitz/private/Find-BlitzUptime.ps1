function Find-BlitzUpTime {
    # Extract Uptime from Result
    param (
        $Result
    )
    $text = $result[0].'Definition: [Property] ColumnName {datatype maxbytes}'
    '{0} days' -f ($text -replace '.*Uptime: ([\d\.]+)','$1')
}