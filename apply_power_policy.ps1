Set-ExecutionPolicy Unrestricted
$powerscheme_location = "C:\power.pow" # set local/network location of power policy

$console_output = powercfg /import $powerscheme_location # import scheme and scrape GUID
$parse = $console_output.Split(":") # stores output based on delimiter
$scheme_guid = $parse[1].Substring(1) # clips the leading whitespace

# Uncomment next line to verify the capture of the correct GUID
#echo $scheme

# Uncomment for changing policy for current user and ignore subsequent lines
#powercfg /s $scheme_guid

# this section creates a key of "ActivePowerScheme" and String value of $scheme_guid
# at the location HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings
$registry_path = "HKLM:\Software\Policies\Microsoft\"
New-Item -Path $registry_path -Name "Power" -ItemType Key
$power_path = $registry_path + "Power\"
New-Item -Path $power_path -Name "PowerSettings" -ItemType Key
$powerSettings_path = $power_path + "PowerSettings\"
New-ItemProperty -Path $powerSettings_path -Value $scheme_guid -PropertyType String -Name "ActivePowerScheme"