<#  
.SYNOPSIS  
    test script
.DESCRIPTION  
    This script does nothing so far.
.NOTES  
    Author		:	Ashley Bickerstaff
	Contributor	:	
    File Name	:	
    Language	:	PowerShell
	Updated		:	20/04/2016
    Version		:	0.1
.LINK  
#>

#Set Error Action to Silently Continue
#$ErrorActionPreference = "SilentlyContinue"

Param([Parameter(Mandatory=$true)][string]$Entry)

# Load Active Directory
Import-Module ActiveDirectory

# Prompt for entry of details and store in variable.
#$UserNameEntry = Read-Host -Prompt 'Enter Username'

# Export DisplayName Property of account & Copy to clipboard
    #$DisplayName = (Get-ADUser -Identity $UserNameEntry -Properties DisplayName).DisplayName | clip
    $DisplayName = (Get-ADUser -Identity $Entry -Properties DisplayName).DisplayName | clip
    Write-output ($DisplayName)
