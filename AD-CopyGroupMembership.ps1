$OU = "OU=YourUsersOU,DC=yourdomain,DC=co,DC=uk"

$SourceUser = Get-ADUser -Server YOUR-DOMAIN-CONTROLLER -Filter * -SearchBase "$OU" | Select-Object DistinguishedName,Enabled,Name,GivenName,Surname,ObjectClass,SamAccountName,UserPrincipalName | Out-GridView -Title "Select user to copy groups FROM" -PassThru
$TargetUser = Get-ADUser -Server YOUR-DOMAIN-CONTROLLER -Filter * -SearchBase "$OU" | Select-Object DistinguishedName,Enabled,Name,GivenName,Surname,ObjectClass,SamAccountName,UserPrincipalName | Out-GridView -Title "Select user to copy groups TO" -PassThru
$SourceUserGroups = Get-ADUser -Server YOUR-DOMAIN-CONTROLLER -Identity $SourceUser.SamAccountName -Properties MemberOf
$SelectedGroups = $SourceUserGroups.MemberOf | Out-GridView -Title "Select groups to add $TargetUser to" -PassThru
#$SelectedGroups | Add-ADGroupMember -Server YOUR-DOMAIN-CONTROLLER -Members $TargetUser.SamAccountName
foreach ($group in $SelectedGroups){
	$body += Add-ADGroupMember -Identity $group -Server YOUR-DOMAIN-CONTROLLER -Members $TargetUser.SamAccountName -PassThru | Select-Object -ExpandProperty SamAccountName
	$body += "`n"
}

Add-Type -AssemblyName System.Windows.Forms
$button = [System.Windows.MessageBoxButton]::OK
$title = "Groups Copied"
$icon = [System.Windows.MessageBoxImage]::Information
[System.Windows.MessageBox]::Show($body,$title,$button,$icon)
