<#  
.SYNOPSIS  
    Report on set attribute from AD
.DESCRIPTION  
    This script takes a note of accounts and a predefined attribute from Active Directory
.NOTES  
    Author		:	Ashley Bickerstaff
	Contributor	:	
    File Name	:	
    Language	:	PowerShell
	Updated		:	07/01/2016
    Version		:	1.0
.LINK  
#>

# Create log file with date stamp
$datestring = (Get-Date).ToString("s").Replace(":","-") 
$file = ".\AccountAttribute_$datestring.log"
Get-Date | Out-File $File

# Load Active Directory Module
Import-Module ActiveDirectory

$DCHostName = (Get-ADDomainController | Select-Object -Property HostName).HostName
$EVUser = [Environment]::UserName
$EVDevice = [Environment]::MachineName
write-output ("Script talking to: " + $DCHostName) | Out-File $file -Append
write-output ("Script ran by: " + $EVUser) | Out-File $file -Append
write-output ("Script ran from: " + $EVDevice) | Out-File $file -Append
"`n"  | Out-File $File -Append

# Loads file with the users. (You can change the filename to reflect your file.)
$path2 = ".\users.csv"
$users = Import-Csv $path2

foreach ($user in $users) {
	$output = (Get-ADUser -Identity $user.samAccountName -Properties EmailAddress).EmailAddress
    write-output ("Username: " + $user.samAccountName + "`r`n" + "Email: " + $output) | Out-File $file -Append
	}
