$OU = "OU=yourUsersOU,DC=yourdomain,DC=co,DC=uk"

$SourceUser = Get-ADUser -Server SYS-ADDC-01 -Filter * -SearchBase "$OU" | Select-Object DistinguishedName,Enabled,Name,GivenName,Surname,ObjectClass,SamAccountName,UserPrincipalName | Out-GridView -Title "Select user to copy groups FROM" -PassThru
$TargetUser = Get-ADUser -Server SYS-ADDC-01 -Filter * -SearchBase "$OU" | Select-Object DistinguishedName,Enabled,Name,GivenName,Surname,ObjectClass,SamAccountName,UserPrincipalName | Out-GridView -Title "Select user to copy groups TO" -PassThru
$SourceUserGroups = Get-ADUser -Server SYS-ADDC-01 -Identity $SourceUser.SamAccountName -Properties MemberOf
$SelectedGroups = $SourceUserGroups.MemberOf | Out-GridView -Title "Select groups to add $TargetUser to" -PassThru
$SelectedGroups | Add-ADGroupMember -Server SYS-ADDC-01 -Members $TargetUser.SamAccountName
