# Asking where the CSV file is
$locationFile = Read-Host "Put the location of the CSV file"

# Asking the password for all users, they gonna have to change it in the first login
$GlobalPassword = Read-Host "Put the password for all users"

# Load datas of the CSV file
$CSVdata = Import-Csv $locationFile -Delimiter ';'

# Asking in wish OU the users are gonna be
$locationOU = Read-Host "Indicate in wish OU the users are gonna be"

# Display the name of the users
Write-Host "User in the file:"
foreach ($user in $CSVdata){
    $surnameUser = $user.SURNAME
    $nameUser = $user.NAME
    Write-Host "- $surnameUser $nameUser"
}

# This gonna read the datas and create users account with the password
foreach ($user in $CSVdata){
	# This define the login of the account that will be used to connect to Windows
    $surnameUser = $user.SURNAME
    $nameUser = $user.NAME
    $login = $user.NAME+'.'+$user.SURNAME
    $loginUser = $login.ToLower()

	# Create user account in the Active Directory with the global password, user will have to change the password after the first login
    New-ADUser -SamAccountName $loginUser -UserPrincipalName "$loginUser@domain.local" -Name "$surnameUtilisateur $nameUtilisateur" -GivenName $nameUser -Surname $surnameUser -AccountPassword (ConvertTo-SecureString $GlobalPassword -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -Path "OU=$locationOU,DC=domain,DC=local"
}

Write-Host "User creation ended with success."
