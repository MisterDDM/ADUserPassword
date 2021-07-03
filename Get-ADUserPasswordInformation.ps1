Function Get-ADUserPasswordInformation
{
	[cmdletbinding()]
	param
	(
		[string]$UserName = $env:USERNAME
	)
	$ADDefaultDomainPasswordPolicy = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
	$Now = Get-Date
	$ADUser = Get-ADUser -Identity $UserName -Properties pwdlastset, BadLogonCount, badPasswordTime, badPwdCount
	
	$PasswordLastChanged = [datetime]::FromFileTime($ADUser.pwdlastset[0])
	$PasswordExpirationDate = $PasswordLastChanged.AddDays($ADDefaultDomainPasswordPolicy)
	$DaysLeftBeforeExpiration = ($PasswordExpirationDate - $Now).Days
	
	$BadPasswordTime = [datetime]::FromFileTime($ADUser.badPasswordTime[0])
	
	$DateLastSet = [datetime]::FromFileTime($ADUser.pwdlastset[0])
	[PSCustomObject]@{
		LastSet		     = $PasswordLastChanged
		ExpiresOn	     = $PasswordExpirationDate
		DaysB4Expiration = $DaysLeftBeforeExpiration
		BadLogonCount    = $ADUser.BadLogonCount
		BadPwdTime	     = $BadPasswordTime
		BadPwdCount	     = $ADUser.badPwdCount
	}
}
