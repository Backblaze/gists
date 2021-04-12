param( 
    [string] $groupID = "",
    [string] $groupToken = "",
    [string] $userEmail = "",
    [string] $workingDirectory,
    [string] $uninstall = "false"
)

#Create log if it doesnt already exist
$LOGNAME = "Backblaze Powershell Deployment"
if ( -not ( [System.Diagnostics.EventLog]::SourceExists($LOGNAME) ) ) {
    New-EventLog -LogName Application -Source $LOGNAME
}

[int]$global:eventIx = 1

##############################FUNCTIONS#################################################
function logOutput {
    param( [string]$out )
    if ( $debug ) {
        write-host "[debug[${global:eventIx}]] $out"
    }
}

function global:echoOutput {
    param( [string]$out )
    Write-EventLog -LogName Application -Source $LOGNAME -EntryType Information -EventID $eventIX -Message $out
    logOutput "event ${global:eventIx}: $out"
    $global:eventIx = $global:eventIx + 1
}

function MyThrow {
    param( [string]$throwMessage )
    echoOutput $throwMessage
    Throw $throwMessage
}

function updateCheck {
    $software = "Backblaze";
    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

    if($installed) {
        runUpdate
        exit
    }
}

function runUpdate {
    
}

function installBackblaze {
    $installCommand = "msiexec.exe /i install_backblazemsi.msi /quiet /l*vx! $BACKBLAZE_LOG_DIR BZEMAIL=$userEmail BZGROUPID=$groupID BZGROUPTOKEN=$groupToken"
    Invoke-Expression $installCommand
}

function installADBackblaze {
    $installADCommand = "msiexec.exe /i install_backblazemsi.msi /quiet /l*vx! $BACKBLAZE_LOG_DIR BZGROUPID=$groupID BZGROUPTOKEN=$groupToken"
    Invoke-Expression $installADCommand
}

function uninstallBackblaze {
    $uninstallCommand = "msiexec.exe /uninstall install_backblazemsi.msi /quiet"
    Invoke-Expression $uninstallCommand
    exit
}

########################################################################################

#Update Check

#Uninstall Check
if ( $uninstall -eq "true") {
    uninstallBackblaze
    exit
}

#Set installer filename
$BACKBLAZE_INSTALLER = 'install_backblazemsi.msi'
$BACKBLAZE_LOG = 'output.log'

#Set install path
if ( $workingDirectory ) {
    $BACKBLAZE_INSTALL_DIR = $workingDirectory
    $BACKBLAZE_LOG_DIR = join-path $BACKBLAZE_INSTALL_DIR $BACKBLAZE_LOG
} else {
    $BACKBLAZE_INSTALL_DIR = "C:\tmp\backblaze_install_dir"
    $BACKBLAZE_LOG_DIR = "C:\tmp\backblaze_install_dir\output.log"
}

#Install path exists?
$ret = test-path $BACKBLAZE_INSTALL_DIR
echoOutput "BACKBLAZE_INSTALL_DIR [$BACKBLAZE_INSTALL_DIR] existence returned as ret [$ret]"
if( -not $ret ) {
    New-Item -ItemType directory -Path $BACKBLAZE_INSTALL_DIR
    echoOutput "Temp directory created at [$BACKBLAZE_INSTALL_DIR]"
}

$msiPath = join-path $BACKBLAZE_INSTALL_DIR $BACKBLAZE_INSTALLER

#Backblaze installer is present?
if ( -not ( test-path -path "$msiPath" ) ) {
    Invoke-WebRequest -Uri "https://secure.backblaze.com/win32/install_backblazemsi.msi" -OutFile $msiPath
    echoOutput "Latest installer download to [$BACKBLAZE_INSTALL_DIR]"
}

#Check parameters
if( -not $groupID ) {
    MyThrow "Error: groupID missing"
}

if( -not $groupToken ) {
    MyThrow "Error: groupToken missing"
}

Set-Location $BACKBLAZE_INSTALL_DIR

if ( $userEmail ) {
    installBackblaze
} else {
    installADBackblaze
}