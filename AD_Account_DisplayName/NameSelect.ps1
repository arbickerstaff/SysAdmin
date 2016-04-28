$path2 = ".\name.csv"
$users = Import-Csv $path2

foreach ($user in $users) {
    #$name = $user.FirstName
    $initial = ($user.FirstName).substring(0,1)
    $DisplayName = ($user.Surname + ($user.FirstName).substring(0,1))
    Write-Output $DisplayName
    }

