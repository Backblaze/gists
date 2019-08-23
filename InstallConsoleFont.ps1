
param (
	[string]$FontName,
	[string]$FontFile,
	[switch]$Help
);

function isAdminMode {
	return ([Security.Principal.WindowsPrincipal] `
	  [Security.Principal.WindowsIdentity]::GetCurrent() `
	).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

####################################
# NULL comes in a number of shapes and forms in powershell 
function isNull($obj) {
	if ( ($obj -eq $null) -or
		 (($obj -is [String]) -and ($obj -eq [String]::Empty)) -or
		 ($obj -is [DBNull]) -or
		 ($obj -is [System.Management.Automation.Language.NullString]) )
	{ return $true; }	
	return $false;
}
####################################
function printHelp {
	#the script name might be 'InstallConsoleFont' but it might have been changed, too
	$scriptName = $MyInvocation.MyCommand.Name
	write-host " "
	write-host "  Usage: $scriptName -FontName <fontname> -FontFile <truetypefontfile>"
	write-host "         add font <fontname> in <truetypefontfile> to console fonts registry key"
	write-host "         <truetypefontfile> must be present in system fonts directory"
	write-host "         Please note that only truetype (.ttf) fonts may be installed to the powershell terminal"
	write-host "         Please note that this script must be run with elevated permissions"
	write-host " "
	write-host "  Usage: $scriptName -Help"
	write-host "         print this message"
	write-host " "
	write-host "  Example: ./$scriptName 'Zen Mono Regular' -FontFile zenmono-r-6.1.3.ttg"
	write-host " "
	exit 0;
}
####################################

if ( 	($Help) -or 
		(isNull($FontName)) -or
		(isNull($FontFile)) -or
		(-not isAdminMode) 	{	
	printHelp
}

$key = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"

## Find out if $FontName is installed on the system
$fontFileName = join-path $env:windir "Fonts\$FontFile"
if(!(test-path $fontFileName))
{
		write-host "File $fontFileName is not present."
		write-host "Please check that the desired font is installed in a .TTF format"
		printHelp
        break
}
 
## Determine if $FontName is already installed as a command window font
$installed = get-itemproperty $key |
             get-member |
             where-object { $_.Name -match "^0+$" } |
             where-object { $_.Definition -match "$FontName" }
             
if($installed -ne $null)
{
    write-host "The $FontName font is already installed as a command window font"
	write-host "or another font is installed with that name ( $FontName )"
	write-host " "
	break
}
 
## Find out what the largest string of zeros is
$zeros = (get-itemproperty $key |
         get-member |
         where-object { $_.Name -match "^0+$" } |
         measure-object).Count
 
## Install the font
new-itemproperty $key -Name ("0" * ($zeros + 1)) -Type string -Value "$FontName"
write-host "$FontName font installed successfully as a command window font."
