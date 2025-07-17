$splatTest = @{
    SqlInstance = 'SQ-DBDD999\TESTME2'
}
BeforeAll {
    Import-Module C:\Users\dba-pollbrod\Code\My\Repo\CafeBlitz.git\CafeBlitz\CafeBlitz.psd1 -Force
}
Describe 'Invoke-CafeBlitz Functionality' {

    #$result = Invoke-CafeBlitz @splatTest
<#    It 'should return a recordset' {
        $result = Invoke-CafeBlitz @splatTest
        $result | Should -BeOfType 'System.Management.Automation.PSCustomObject'
    } #>
    It 'should return a Result' {
        $result = Invoke-CafeBlitz @splatTest
        $result.Result.Count | Should -BeGreaterThan 0
    }
}