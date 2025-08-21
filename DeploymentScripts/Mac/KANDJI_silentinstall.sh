#!/bin/bash

############### Backblaze Variables ###############

# You can find these values in the advanced deployment section of your Backblaze group console.
group_id=""
group_token=""
email="" #If email is entered in parameters, script will skip over using Kandji API, make sure related password is entered as well
region="" #Specify if account is to be deployed in specific region [us-west or eu-central]

############### Kandji Variables ###############

# Set your companies Kandji domain
kandji_domain="<kandji_domain>.api.kandji.io"

# Generate a api token in your Kandji Pro console and paste it below
# https://support.kandji.io/support/solutions/articles/72000560412-kandji-api
api_token=""


# Set the region to deploy to, true for EU, false for US
eu=false

# Will be set by the get_device_id function
device_id=""

# BZERROR MEANINGS
# BZERROR:190 - The System Preferences process is running on the computer. Close System Preferences and retry the installation.
# BZERROR:1000 - This is a general error code. One possible reason is that the Backblaze installer doesn't have root permissions and is failing. Please see the install log file for more details.
# BZERROR:1016/1003 - Login Error... Email account exists but is not a member of indicated Group, Group ID is incorrect, or Group token is incorrect,

################ FUNCTIONS #########################

function update_backblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -upgrade bzdiy)
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
		echo "Failed to retrieve valid email address from Kandji API. Parsed Email: [ $email ]"
		echo "Please make sure Kandji credentials have READ access on the user object and endpoints have emails properly set"
		failure_exit
	else
		echo "The email retrieved from Kandji API [ $email ] seems to be a valid email address"
		echo "Continuing with install"
	fi
}

function get_device_id {
    device_id=$(defaults read /Library/Preferences/io.kandji.Kandji ComputerURL | cut -d '/' -f 5)
    if [ ! -f /Library/Preferences/io.kandji.Kandji ]; then
        echo "Kandji config file not found, please verify target computer has a kandji config file, if located elsewhere you can change path in line 61.  Exiting."
        failure_exit
    fi
}

function set_kandji_domain {
	#Set kandji domain based on region
    if [ "$eu" == false ]; then
        domain="https://$kandji_domain.api.kandji.io"
    else
        domain="https://$kandji_domain.eu.api.kandji.io"
    fi
}

function kandji_get_device_email {
	set +H
	echo "Making GET request to Kandji PRO API using Username"
	response=$(curl --location -g "$domain/api/v1/devices/$device_id/details" --header "Authorization: Bearer $api_token")
	set -H

	email=$(echo "$response" | awk -F'"email":' '{print $2}' | awk -F'"' '{print $2}')
	email_validation
}

function success_exit {
    echo "Unmounting Installer..."
    hdiutil detach "/Volumes/Backblaze Installer" -force 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Successfully unmounted Backblaze Installer."
    elif [ $? -ne 0 ]; then
        echo "Warning: Failed to unmount /Volumes/Backblaze Installer. It may not have been mounted."
    fi

    echo "Cleaning up..."
    rm -f install_backblaze.dmg
    if [ $? -ne 0 ]; then #Very unlikely to fail, but still good practice
        echo "Warning: Couldnt remove dmg file"
    fi

    echo "Backblaze installation successful."
    exit 0
}

function failure_exit {
    echo "Unmounting Installer..."
    hdiutil detach "/Volumes/Backblaze Installer" -force 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Successfully unmounted Backblaze Installer."
    elif [ $? -ne 0 ]; then
        echo "Warning: Failed to unmount /Volumes/Backblaze Installer. It may not have been mounted."
    fi

    echo "Cleaning up..."
    rm -f install_backblaze.dmg
    if [ $? -ne 0 ]; then
        echo "Warning: Couldnt remove dmg file"
    fi

    echo "Backblaze installation failed."
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

    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to mount install_backblaze.dmg"
        exit 1
    fi

    echo "install_backblaze.dmg mounted successfully."
}

#Function to unmount all mounted DMGs just in case previous mounts were not unmounted
function unmount_backblaze {
    echo "Unmounting Backblaze Installer..."
    hdiutil detach "/Volumes/Backblaze Installer" -force 2>/dev/null
}

###################################################

set_directory "$@"
download_backblaze
unmount_backblaze
mount_backblaze
get_device_id
set_kandji_domain

#Kill System Preferences process to prevent related BZERROR
kill_syspref

#Check to see if Backblaze is installed already, if so update it. Else continue as planned.
if open -Ra "Backblaze" ; then
	echo "Backblaze already installed, attempting to update"
	update_backblaze
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze successfully updated"
		success_exit
	else
		#Try upgrade again incase there was a file lock on the mounted dmg causing errors
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
	echo "Confirmed Backblaze isnt installed already, continuing with deployment..."
fi

#If email wasnt passed in from parameters, assume we need to access Kandji API to retrieve it
if [ "$email" == "" ]; then
	echo "Email not hardcoded, attempting to pull from Kandji Pro API"
	kandji_get_device_email
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
