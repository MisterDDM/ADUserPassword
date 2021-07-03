Function Reset-ADUserPasswordCounter
{
    [cmdletbinding()]
    param
    (
        [string]$UserName = $env:USERNAME,
        [switch]$Confirm
    )
    if ( $PSBoundParameters['Confirm'] )
    {
        $ADUser = Get-ADUser -Identity $UserName -Properties pwdlastset
        
        $ADUser.pwdlastset = 0
        Set-ADUser -Instance $ADUser
        
        $ADUser.pwdlastset = -1
        Set-ADUser -Instance $ADUser
                
        $ADUser = Get-ADUser -Identity $UserName -Properties pwdlastset
        $DateLastSet = [datetime]::FromFileTime( $ADUser.pwdlastset[0] )
        [PSCustomObject]@{
            UserName = $UserName
            PasswordCountReset = $DateLastSet
        }

    }
    else
    {
        Get-ADUserPasswordLastSet -UserName $UserName
    }
}
