<#  
.SYNOPSIS  
    Disable, tidy & Move Active Directory Accounts
.DESCRIPTION  
    This script 
.NOTES  
    Author		:	Ashley Bickerstaff
    File Name	:	DisableAndTidyADAccounts.ps1
    Language	:	PowerShell
    Updated		:	27/02/2015
    Version		:	0.1
.LINK  
#>

#Create log file
$datestring = (Get-Date).ToString("s").Replace(":","-") 
$file = ".\Disabled_Users_$datestring.log"
Get-Date | Out-File $File

#Load AD Module 
Import-Module ActiveDirectory

#Exchange 2007
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

#Import CSV File 
$list = Import-Csv ".\DisableUsers.csv" 

#Gets information on account for refrence and adds to log
ForEach ($entry in $list) 
{ 
	$samAccountName = $entry.samAccountName
	Get-ADUser -Identity $samAccountName -Properties Office,AccountExpirationDate,Department,Enabled,homeDrive,homeDirectory,LastLogonDate,EmailAddress,memberof | Out-File $file -Append
}
	
#Sets AD Account to Disabled then writes result to file
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	Set-ADUser -Identity $samAccountName -Enabled $false -PassThru | Out-File $file -Append
}

#Remove all groups except Domain Users
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	$users = (Get-ADUser $samAccountName -properties memberof).memberof
	$users | Remove-ADGroupMember -Members $samAccountName -Confirm:$false
}

#Sets Office Field to Disabled and Date
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	Get-ADUser -Identity $samAccountName | Set-ADUser -Office "Disabled_$datestring"
}

#Delete home drive data from share
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	$path = (Get-ADUser $samAccountName -properties homedirectory).homedirectory
	Remove-Item $path -recurse
}

#Clears Home directory
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	Get-ADUser -Identity $samAccountName | Set-ADUser -HomeDirectory $null
}

#Hide on GAL
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	Get-Mailbox -Identity $samAccountName | Set-Mailbox -HiddenFromAddressListsEnabled $True | Out-File $file -Append
}

#Move Account to Pending Deletions
foreach ($entry in $list)
{
	$samAccountName = $entry.samAccountName
	Get-ADUser -Identity $samAccountName | Move-ADObject -TargetPath "OU=Deletions,OU=blah,dc=blah,dc=corp,dc=contoso,dc=com"
}
