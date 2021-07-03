Function Get-ADUserPasswordLastSet 
{
    [cmdletbinding()]
    param
    (
        [string]$UserName = $env:USERNAME
    )

    $ADUser = Get-ADUser -Identity $UserName -Properties pwdlastset
    $DateLastSet = [datetime]::FromFileTime( $ADUser.pwdlastset[0] )
    [PSCustomObject]@{
        UserName = $UserName
        PasswordLastSet = $DateLastSet
    }
}
