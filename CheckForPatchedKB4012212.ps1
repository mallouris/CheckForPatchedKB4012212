# Script by Stephanos Mallouris, After the outbreak of the malware WannaCRY
# to check your Active Directory Infrastrutcure, the AD computer clients with Windows 7 OS
# if they are Patched or NOT against the exploitation of the MS SMBv1 implimentation

import-module ActiveDirectory
$ADCompNames = Get-ADComputer -Filter  {OperatingSystem -Like "Windows 7*"} | Select-Object Name
$LiveComputers = New-Object System.Collections.Generic.List[System.Object]
ForEach ($ADCompName in $ADCompNames)
{ 
 if(Test-Connection -Computername $ADCompName.Name -BufferSize 16 -Count 1 -Quiet) 
 { "Host " + $ADCompName.Name + " is alive" ; 
    $LiveComputers.Add($ADCompName.Name);
    if (!(get-hotfix -id KB4012212 -computername $ADCompName.Name))
    {
     add-content $ADCompName.Name -path Win7UnpatchedKB4012212.txt
    }
    else
    {
    add-content $ADCompName.Name -path Win7PatchedKB4012212.txt
    }
 }
 else
 {
  $ADCompName.Name + " is not responding. "
 }
}
