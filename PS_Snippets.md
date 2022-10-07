# PowerShell Snippets

These are a collection of useful and random snippets that I have used over the years. Stored here for reference and easy location.

This snip will get the on time for a remote pc.
```powershell
$ComputerName = Read-Host "Please enter computer name"
Get-WmiObject Win32_Process -ComputerName $ComputerName | Select-Object Name, @{Name="CPU_Time"; Expression={$_.kernelmodetime + $_.usermodetime}} | Sort-Object CPU_Time -Descending | Out-GridView
```

This a a little powershell snip to get and kill a process running on a remote machine.
```powershell
$Computer = Read-Host "Please enter computer name"
$process1 = Read-Host "Please enter process to kill"
$process = Get-Process -ComputerName $Computer -Name $process1
$process.Kill()
```

This is there to use to test scripts for use. This will then output a time to run on screen.
```powershell
Measure-Command -Expression {
  # Insert script in here
}
```

This snip will check the domain you are on for empty AD groups.
```powershell
Get-ADGroup -Filter * -Properties Members | where { $_.Members.Count -eq 0 }
```

This will locate the domain, get the details to use as a search base. FRom there it counts the OUs in the domain.
```powershell
$DomainDistinguishedName = (Get-ADDomain).DistinguishedName
$OUCount = @(Get-ADOrganizationalUnit -filter * -SearchBase $DomainDistinguishedName -SearchScope Subtree) | measure | select Count 
$OUCount
```

Get the OU that has been assigned for storing users.
```powershell
$DomainUserContainer = (Get-ADDomain).UsersContainer
```

This will get the accounts that have not logged in for the last 60 days.
```powershell
$DomainDistinguishedName = (Get-ADDomain).DistinguishedName
$60DaysAgo = (Get-Date).AddDays(-60)
#Get-ADUser –filter * -SearchBase $DomainDistinguishedName | Where { $_.lastLogon –lt (Get-Date).AddDays(-60) } | ConvertTo-HTML –PreContent 'Users' –Prop Name,samAccountName,LastLogon | Out-File $FinalReport

Get-ADUser –filter * -SearchBase $DomainDistinguishedName | Where { $_.lastLogon –lt $60DaysAgo } | measure | select Count
```

Obtain a list of users where the password has not been set.
```powershell
Get-ADUser –filter * -prop PasswordLastSet | Where { $_.passwordLastSet –eq $null } | measure | select Count
```

Obtain a list of the OUs within AD.
```powershell
$DomainDistinguishedName = (Get-ADDomain).DistinguishedName
$OUlist1 = @(Get-ADOrganizationalUnit -filter * -SearchBase $DomainDistinguishedName -SearchScope OneLevel | measure | select Count)
$OUlist1

$OUlist2 = @(Get-ADOrganizationalUnit -filter * -SearchBase $DomainDistinguishedName -SearchScope OneLevel | Where { $_.Name -notlike "CDA" } | measure | select Count)
$OUlist2
```

```powershell
$Domain = Get-ADDomain
$DNSRoot = $Domain.DNSRoot
"<h1> Active Directory Information for : $DNSRoot </h1><hr>" >> $FinalReport

"<h2>Domain Controllers</h2>" >> $FinalReport	

# Gathers the DistinguishedName of the domain connected to which is then used for most further searching.
$DistinguishedDomain = $Domain.DistinguishedName
```

Prompt for entry of details and store in variable. Then export all account properties from input.
```powershell
$UserNameEntry = Read-Host -Prompt 'Enter Username'
Get-ADUser -Identity $UserNameEntry.samAccountName -Properties * | Out-GridView
```

Convert file to a Base64 string
```powershell
$content = get-content -path C:\image.png -encoding byte
$base64 = [System.Convert]::ToBase64String($content)
$base64 | Out-File C:\encoded.txt
```


:octocat:
```powershell
```
