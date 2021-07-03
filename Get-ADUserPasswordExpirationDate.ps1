Function Get-ADUserPasswordExpirationDate
{
    [cmdletbinding()]
    param
    (
        [string]$UserName = $env:USERNAME
    )

    $ADDefaultDomainPasswordPolicy = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
    $Now = Get-Date
    $PasswordLastChanged = Get-ADUserPasswordLastSet -UserName $UserName
    $PasswordExpirationDate = $PasswordLastChanged.PasswordLastSet.AddDays($ADDefaultDomainPasswordPolicy)
    $DaysLeftBeforeExpiration = ($PasswordExpirationDate - $Now).Days

    [PSCustomObject]@{
        UserName = $UserName
        LastChanged = $PasswordLastChanged.PasswordLastSet
        Expiration = $PasswordExpirationDate
        DaysLeft = $DaysLeftBeforeExpiration
    }
}
