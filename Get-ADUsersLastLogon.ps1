Import-Module ActiveDirectory

$TesterAccount = "tester"

function Get-ADUsersLastLogon(){    
    $dcs = Get-ADDomainController -Filter {Name -like "*"}
    $user = Get-ADUser -Identity $TesterAccount
    $time = 0

    foreach($dc in $dcs){ 

        $hostname = $dc.HostName
        $currentUser = Get-ADUser $user.SamAccountName | Get-ADObject -Server $hostname -Properties lastLogon

        if($currentUser.LastLogon -gt $time){
            $time = $currentUser.LastLogon
        }
    }

    $dt = [DateTime]::FromFileTime($time)
    $row = $user.Name+" - "+$user.SamAccountName+" - "+$dt
    $row | Out-GridView
    $time = 0
}

Get-ADUsersLastLogon
