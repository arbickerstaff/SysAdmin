<#  
.SYNOPSIS  
    Bulk Active Directory Creations ACCESS
.DESCRIPTION  

.NOTES  
    Author		:	Ashley Bickerstaff
	Contributor	:	
    File Name	:	
    Language	:	PowerShell
	Updated		:	24/06/2015
    Version		:	0.1
.LINK  
#>

# Create log file
$datestring = (Get-Date).ToString("s").Replace(":","-") 
$file = ".\Account_Creations_$datestring.log"
Get-Date | Out-File $File
   
# Load Active Directory Module + Exchange 2007
Import-Module ActiveDirectory  -ErrorAction SilentlyContinue
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

# Loads file with the users. (You can change the filename to reflect your file.)
$path2 = $PSScriptRoot + "\NewUsers.csv"
$users = Import-Csv $path2

# Get domain DNS suffix + Set home drive server name + Set the default password
$dnsroot = '@' + (Get-ADDomain).dnsroot
$defpassword = (ConvertTo-SecureString "Enter Password" -AsPlainText -force)

foreach ($user in $users) {
	$check = $null
	$check = Get-ADUser -identity $user.username
	If ($check) {
	Write-Warning -message("Error! Username: " + $user.username + " already exists on Active Directory.") | out-file $file -append 
	} Else {
		# Scripting for ACCESS Staff Level 1 specific.
		$NewUser = New-ADUser -SamAccountName $user.username -Path "OU=Accounts,OU=blah,dc=blah,dc=corp,dc=contoso,dc=com" -Name ($user.FirstName + " " + $user.LastName) -DisplayName ($user.LastName + ", " + $user.FirstName + " (ACCESS LLP)") -GivenName $user.FirstName -Surname $user.LastName -UserPrincipalName ($user.username + $dnsroot) -Title "Manager" -Department "Admin" -StreetAddress "Blah" -City "Blah" -PostalCode "Blah" -HomePhone "0123 456 7891" –HomeDrive 'F:' -HomeDirectory ("\\Server\Location\" + $user.username) -Enabled $true -ChangePasswordAtLogon $true -PasswordNeverExpires  $false -AccountPassword $defpassword -PassThru
		# Add permissiont to account after 10 second pause
        Start-Sleep -s 10
		Add-DistributionGroupMember -Identity "Enter Group Name" -Member $user.username 
		Add-ADGroupMember -Identity "Enter Group Name" -Members $NewUser
		# Create home folder on share
		New-Item -Path "\\Server\Location\" -name $user.username -ItemType directory
		# Set permissions on holder on share
		$Acl = Get-Acl ("\\Server\Location\" + $user.username)
		$Rule = New-Object  system.security.accesscontrol.filesystemaccessrule($user.username,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
		$Acl.SetAccessRule($Rule)
		Set-Acl ("\\Server\Location\" + $user.username) $Acl
		# Create mailbox for new account
		Enable-Mailbox -Identity ("Domain\" + $user.username) -Database "Enter DB"
	}
}
