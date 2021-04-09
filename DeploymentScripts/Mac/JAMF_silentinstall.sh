#!/bin/bash

# The following parameters are pulled directly from the "Parameter Values" section of your Backblaze deployment policy.
# Please make sure they are filled out respectively prior to your push
username="$3"
groupid="$4"
grouptoken="$5"
email="$6" #If email is entered in parameters, script will skip over using JAMF API, make sure related password is entered as well
password="$7"
JAMF_domain="$8"

# The script needs access to the JAMF Pro API to gather related the related email for a given user 
# Account just needs to have Users - Read permissions
# You can configure a temp account for this in the "Jamf Pro User Accounts & Groups" section of your console
JAMF_username="$9"
JAMF_password="${10}"

################ FUNCTIONS #########################
function updateBackblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -upgrade bzdiy)
}

function signinBackblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -signin $email $password)
}

function createaccountBackblaze {
	return=$(sudo /Volumes/Backblaze\ Installer/Backblaze\ Installer.app/Contents/MacOS/bzinstall_mate -nogui -createaccount $email $password $groupid $grouptoken)
}

function emailValidation {
	[[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
	rc=$?
	if [ "$rc" != "0" ]
		then
    		echo "The email retrieved from JAMF [$email] is an invalid email address"
			echo "Please make sure JAMF credentials have READ access on the user object and endpoints have emails properly set"
    		exit 1
		else
			echo "The email retrieved from JAMF [$email] seems to be a valid email address"
			echo "Continuing with install"
	fi
}

function jamfAPI {
	echo "Making GET request to Classic JAMF API"
	response=$(curl -s "https://$JAMF_domain.jamfcloud.com/JSSResource/users/name/$username" -u "$JAMF_username:$JAMF_password")

	email=$(echo $response | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}')
	emailValidation
}

function successExit {
	echo "Unmounting Installer..."
	diskutil unmount /Volumes/Backblaze\ Installer
	echo "Cleaning up..."
	rm install_backblaze.dmg
	exit 0
}

function failureExit {
	echo "Unmounting Installer..."
	diskutil unmount /Volumes/Backblaze\ Installer
	echo "Cleaning up..."
	rm install_backblaze.dmg
	exit 1
}

function killSyspref {
	killall -KILL System\ Preferences > /dev/null 2>&1
}

function setDirectory {
	if [ -n "$3" ] 
	then 
		cd /Users/"$3" || { echo "Failed to cd to user directory"; exit 1; }
	fi
}

function downloadBackblaze {
	echo "Downloading latest backblaze client..."
	curl -s -O https://secure.backblaze.com/mac/install_backblaze.dmg
}

function mountBackblaze {
	echo "Mounting Installer..."
	hdiutil attach -quiet -nobrowse install_backblaze.dmg 
}
###################################################

setDirectory "$@"
downloadBackblaze
mountBackblaze

#Kill System Preferences process to prevent related BZERROR
killSyspref

#Check to see if Backblaze is installed already, if so update it. Else continue as planned. 
if open -Ra "Backblaze" ; 
	then
  		echo "Backblaze already installed, attempting to update"
		updateBackblaze
		if [ "$return" == "BZERROR:1001" ]
			then
		   		echo Backblaze successfully updated
				successExit
			else
				#Try upgrade again incase there was a file lock on the mounted dmg causing errors
				updateBackblaze
				if [ "$return" == "BZERROR:1001" ]
					then
		   				echo Backblaze successfully updated
						successExit
					else
						echo "Backblaze was already installed but failed to update"
						failureExit
				fi
		fi
	else
  		echo "Confirmed Backblaze isnt installed already, continuing with deployment..."
fi

#If email wasnt passed in from parameters, assume we need to access JAMF API to retrieve it
if [ "$email" == "" ]
 then
	echo "Email not hardcoded, attempting to pull from JAMF Pro API"
	jamfAPI
fi

echo "Trying to sign in account"
signinBackblaze
if [ "$return" == "BZERROR:1001" ]
	then
	    echo Backblaze installed, $email already had an account with Backblaze
		successExit
	else
	   	echo "Account doesnt exist, trying to create account"
		createaccountBackblaze
		if [ "$return" == "BZERROR:1001" ]
			then
		   		echo Backblaze installed, account created and licensed to $email
				successExit
			else
				echo "Create account failed, trying signing in account again"
   				signinBackblaze
				if [ "$return" == "BZERROR:1001" ]
					then
						echo Backblaze installed, $email already had an account with Backblaze
						successExit
					else
						echo Failed to install Backblaze, errorcode: $return
                        failureExit
				fi
		fi
fi