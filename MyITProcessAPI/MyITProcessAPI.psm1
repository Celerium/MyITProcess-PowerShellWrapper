$MyITProcess_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$MyITProcess_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "MyITProcess_Headers" -Value $MyITProcess_Headers -Scope global

Import-MyITProcessModuleSettings