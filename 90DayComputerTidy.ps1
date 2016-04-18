<#  
.SYNOPSIS  
    Disable & Move Computer Objects
.DESCRIPTION  
    This script create Log file for work, take note of computer object before script, Remove groups from object & Move Computer object OU.
.NOTES  
    Author		:	Ashley Bickerstaff
    File Name	:	90DayComputerTidy.ps1
    Language	:	PowerShell
    Updated		:	03/03/2015
    Version		:	0.1
.LINK  
#>

#Create log file
$datestring = (Get-Date).ToString("s").Replace(":","-") 
$file = ".\Disabled_Computers_$datestring.log"
Get-Date | Out-File $File

# Load Active Directory Module & Import CSV File
Import-Module ActiveDirectory
$list=Import-Csv ".\Computers.csv" 

#Sets AD Computer Object to Disabled & moves to OU to hold.
foreach ($entry in $list) {
	Get-ADComputer -Identity $entry.computername | Disable-ADAccount -PassThru | Out-File $file -Append
	Get-ADComputer -Identity $entry.computername | Move-ADObject -TargetPath "OU=Deletions,OU=blah,dc=blah,dc=corp,dc=contoso,dc=com"
}
