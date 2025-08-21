#!/bin/bash

# All variables can be hardcoaded if not using using a JAMF policy, by default however it will pull from your policy parameters.

############### Backblaze Variables ###############

# The following parameters are pulled directly from the "Parameter Values" section of your Backblaze deployment policy.
# You can find these values in the advanced deployment section of your Backblaze group console.
# Please make sure they are filled out respectively prior to your push
group_id="$4"
group_token="$5"
email="$6" # If email is entered in parameters, script will skip over using JAMF API, make sure related password is entered as well
region="$7" # Specify if account is to be deployed in specific region [us-west or eu-central]

############### JAMF Variables ####################

# The script needs access to the JAMF Pro API to gather the related email for a given user
# Account just needs to have Users - Read permissions
# You can configure a temp account for this in the "Jamf Pro User Accounts & Groups" section of your console
computer_name="$2"
user_name="$3"
jamf_domain="$8"
jamf_user_name="$9"
jamf_password="${10}"

############### Script Variables ####################
bearer_token=""
email_retrieved_from_computer_name=false


############### BZERROR MEANINGS ###################
# BZERROR:190 - The System Preferences process is running on the computer. Close System Preferences and retry the installation.
# BZERROR:1000 - This is a general error code. One possible reason is that the Backblaze installer doesn't have root permissions and is failing. Please see the install log file for more details.
# BZERROR:1016/1003 - Login Error... Email account exists but is not a member of indicated Group, Group ID is incorrect, or Group token is incorrect,


################ FUNCTIONS #########################
function update_backblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -upgrade bzdiy)
}

function sign_in_backblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -createaccount_or_signinaccount "$email" "$group_id" "$group_token")
}

function create_region_account {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -createaccount_or_signinaccount "$email" "$group_id" "$group_token" "$region")
}

function email_validation {
	[[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
	rc=$?
	if [ "$rc" != "0" ]; then
		if [ "$email_retrieved_from_computer_name" = true ]; then
			echo "Failed to retrieve valid email address from JAMF API. Parsed Email: [ $email ]"
			echo "Please make sure JAMF credentials have READ access on the user object and endpoints have emails properly set"
			failure_exit
		else
			echo "Failed to retrieve valid email address from JAMF API. Attempting to use computer name"
			jamf_api_computer_name
		fi
	else
		echo "The email retrieved from JAMF API [ $email ] seems to be a valid email address"
		echo "Continuing with install"
	fi
}

function get_auth_token {
	set +H
	echo "Making POST request to JAMF PRO API to retrieve bearer token"
	response=$(curl -s -u "$jamf_user_name":"$jamf_password" "https://$jamf_domain.jamfcloud.com/api/v1/auth/token" -X POST)
	set -H

	bearer_token=$(echo "$response" | plutil -extract token raw -)
}

function jamf_api_user_name {
	set +H
	echo "Making GET request to JAMF PRO API using Username"
	response=$(curl -s "https://$jamf_domain.jamfcloud.com/JSSResource/users/name/$user_name" -H "Authorization: Bearer $bearer_token")
	set -H

	email=$(echo "$response" | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}')
	email_validation
}

function jamf_api_computer_name {
	echo "Making GET request to JAMF PRO API using Computer Name"
	set +H
	response=$(curl -s "https://$jamf_domain.jamfcloud.com/JSSResource/computers/name/$computer_name" -H "Authorization: Bearer $bearer_token")
	set -H

	email=$(echo "$response" | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}')
	email_retrieved_from_computer_name=true
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
	if [ -n "$3" ]; then
		cd /Users/"$3" || { echo "Failed to cd to user directory"; failure_exit; }
	fi
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
get_auth_token

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

# If email wasn't passed in from parameters, assume we need to access JAMF API to retrieve it
if [ "$email" == "" ]; then
	echo "Email not hardcoded, attempting to pull from JAMF Pro API"
	jamf_api_user_name
fi

echo "Trying to sign in account"

if [ "$region" == "" ]; then
	sign_in_backblaze
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze successfully installed, $email signed in..."
		success_exit
	else
		sign_in_backblaze
		if [ "$return" == "BZERROR:1001" ]; then
			echo "Backblaze successfully installed, $email signed in..."
			success_exit
		else
			echo "Failed to install Backblaze, error code: $return"
			failure_exit
		fi
	fi
else
	create_region_account
	if [ "$return" == "BZERROR:1001" ]; then
		echo "Backblaze account successfully created in $region, $email signed in..."
		success_exit
	else
		echo "Failed to install Backblaze, error code: $return"
		failure_exit
	fi
fi
