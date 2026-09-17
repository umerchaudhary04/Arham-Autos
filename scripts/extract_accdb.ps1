param (
    [Parameter(Mandatory=$true)]
    [string]$DbPath,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

try {
    # Determine bitness and connection string
    $connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$DbPath;"
    
    $conn = New-Object System.Data.OleDb.OleDbConnection($connString)
    $conn.Open()
    
    # Get schema tables to find all user tables
    $schema = $conn.GetSchema("Tables")
    
    $result = @{}
    
    foreach ($row in $schema.Rows) {
        if ($row.TABLE_TYPE -eq "TABLE" -and $row.TABLE_NAME -notmatch "^MSys") {
            $tableName = $row.TABLE_NAME
            
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "SELECT * FROM [$tableName]"
            $adapter = New-Object System.Data.OleDb.OleDbDataAdapter($cmd)
            $table = New-Object System.Data.DataTable
            $adapter.Fill($table) | Out-Null
            
            $rowsArray = @()
            foreach ($dataRow in $table.Rows) {
                $rowObj = @{}
                foreach ($col in $table.Columns) {
                    $val = $dataRow[$col.ColumnName]
                    if ($val -is [DBNull]) { $val = $null }
                    $rowObj[$col.ColumnName] = $val
                }
                $rowsArray += $rowObj
            }
            
            $result[$tableName] = $rowsArray
        }
    }
    
    $conn.Close()
    
    # Write to JSON
    $result | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputPath -Encoding UTF8
    
    Write-Output "SUCCESS"
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
