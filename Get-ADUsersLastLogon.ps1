Import-Module ActiveDirectory

$TesterAccount = "tester"

function Get-ADUsersLastLogon() {
    $dcs = Get-ADDomainController -Filter {Name -like "*"}
    $user = Get-ADUser -Identity $TesterAccount
    $MyArrayList = New-Object -TypeName "System.Collections.ArrayList"

    foreach($dc in $dcs) {
        $time = 0
        $hostname = $dc.HostName
        if (Test-Connection -Computer $hostname -Count 2 -Quiet) {
            $currentUser = Get-ADUser $user.SamAccountName | Get-ADObject -Server $hostname -Properties lastLogon
            if($currentUser.LastLogon -gt $time){
                $time = $currentUser.LastLogon
                $dt = [DateTime]::FromFileTime($time)
                $lastLogon = $dt
            } else {
                $lastLogon = $time
            }
        } else {
            $lastLogon = "server did not respond"
        }
        $row = [PSCustomObject]@{
                                Host = $hostname;
                                User = $user.Name;
                                LastLogon = $lastLogon
                                }
        $MyArrayList += $row
        $row
    }

    $MyArrayList | Out-GridView
}

Get-ADUsersLastLogon
