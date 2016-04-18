# Title:	Update group and state
# Language:	PowerShell
# Author:	Ashley Bickerstaff
# Date:		14/07/2015
# Version:	0.1
# ----------------------------------------

# Load Active Directory Module
Import-Module ActiveDirectory

# Loads file with the users. (You can change the filename to reflect your file.)
$path2 = "C:\Scripts\Users.csv"
$users = Import-Csv $path2

foreach ($user in $users) {
	# Set state / province field with value from CSV
    Get-ADUser -Identity $user.username | Set-ADUser -State $user.state
	}

foreach ($user in $users) {
	# Added selected user to set group in csv
	Add-ADGroupMember -Identity $user.group -Members $user.username
	}