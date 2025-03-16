#!/bin/bash

############### Backblaze Variables ###############

# Default values (can be overridden by command-line arguments)
group_id=""
group_token=""
email="" 
region="" # Specify if account is to be deployed in specific region [us-west or eu-central]

# BZERROR MEANINGS 
# BZERROR:190 - The System Preferences process is running on the computer. Close System Preferences and retry the installation.
# BZERROR:1000 - This is a general error code. One possible reason is that the Backblaze installer doesn't have root permissions and is failing. Please see the install log file for more details.
# BZERROR:1016/1003 - Login Error... Email account exists but is not a member of indicated Group, Group ID is incorrect, or Group token is incorrect,

################ FUNCTIONS #########################

function update_backblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate --silentUpgrade)
}

function signin_backblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -createaccount_or_signinaccount "$email" "$group_id" "$group_token")
}

function create_region_account {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -createaccount_or_signinaccount "$email" "$group_id" "$group_token" "$region")
}

function email_validation {
	[[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
	rc=$?
	if [ "$rc" != "0" ]; then
		echo "Failed to retrieve valid email address. Parsed Email: [ $email ]"
		echo "Please make sure variables are set" 
		exit 1
	else
		echo "Email: [ $email ] seems to be a valid email address"
		echo "Continuing with install"
	fi
}

function success_exit {
	echo "Unmounting Installer..."
	diskutil unmount /Volumes/Backblaze\ Installer
	echo "Cleaning up..."
	rm install_backblaze.dmg
	exit 0
}

function failure_exit {
	echo "Unmounting Installer..."
	diskutil unmount /Volumes/Backblaze\ Installer
	echo "Cleaning up..."
	rm install_backblaze.dmg
	exit 1
}

function kill_syspref {
	killall -KILL System\ Preferences > /dev/null 2>&1
}

function set_directory {
	cd "$HOME" || { echo "Failed to cd to user directory"; exit 1; }
}

function download_backblaze {
	echo "Downloading latest backblaze client..."
	curl -s -O https://secure.backblaze.com/mac/install_backblaze.dmg
}

function mount_backblaze {
	echo "Mounting Installer..."
	hdiutil attach -quiet -nobrowse install_backblaze.dmg 
}
###################################################

set_directory "$@"
download_backblaze
mount_backblaze

# Parse command-line arguments
while getopts "g:t:e:r:" opt; do
  case $opt in
    g) group_id="$OPTARG" ;;
    t) group_token="$OPTARG" ;;
    e) email="$OPTARG" ;;
    r) region="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Validate email exists
email_validation

# Kill System Preferences process to prevent related BZERROR
kill_syspref

# Check to see if Backblaze is installed already, if so update it. Else continue as planned. 
if open -Ra "Backblaze" ; then
	echo "Backblaze already installed, attempting to update"
	update_backblaze
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze successfully updated"
		success_exit
	else
		# Try upgrade again in case there was a file lock on the mounted dmg causing errors
		update_backblaze
		if [ "$return" == "BZERROR:1001" ]; then
			echo "Backblaze successfully updated"
			success_exit
		else
			echo "Backblaze was already installed but failed to update"
			failure_exit
		fi
	fi
else
	echo "Confirmed Backblaze isn't installed already, continuing with deployment..."
fi

echo "Trying to sign in account"

if [ "$region" == "" ]; then
	signin_backblaze
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze successfully installed, $email signed in..."
		success_exit
	else
		signin_backblaze
		if [ "$return" == "BZERROR:1001" ]; then
			echo "Backblaze successfully installed, $email signed in..."
			success_exit
		else
			echo "Failed to install Backblaze, errorcode: $return"
			failure_exit
		fi
	fi
else 
	create_region_account
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze account successfully created in $region, $email signed in..."
		success_exit
	else
		echo "Failed to install Backblaze, errorcode: $return"
		failure_exit
	fi	
fi