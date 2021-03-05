#!/bin/sh

#These are for debugging and should be turned off; there is better
#   error checking in the script which gather information after an
#   error.
#set -x
#set -euo pipefail

########################################
# Get useful information on encountered error
function debugInfo() {
	now=$(date '+%A %-d %b %-I:%M:%S %p')
	logdir=$(pwd -L)
	physdir=$(pwd -P)
	SOURCE="${BASH_SOURCE[0]}"
	# resolve $SOURCE until the file is no longer a symlink
	while [ -h "$SOURCE" ]; do
		CALLDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
		SOURCE="$(readlink "$SOURCE")"
		[[ $SOURCE != /* ]] && SOURCE="$CALLDIR/$SOURCE"
		# if $SOURCE was a relative symlink, we need to resolve it
		#   relative to the path where the symlink file was located
	done
	CALLDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
	echo " "
	echo "$now"
	echo "script called as: $0 from $CALLDIR "
	echo "physical / logical directory:  [ $physdir ] / [ $logdir ] "
	echo " "
}
########################################

backblaze_grpID="$4"
backblaze_grpToken="$5"

#By default $3 is the username parameter for scripts in Jamf
userName="$3"

## method 1: query JAMF for username information
response=$(curl https://myjss.com/JSSResource/users/name/$userName --user username:password -H "Accept: application/xml")

#Jamf API’s can return XML or JSON, this parses and grabs the email from XML.
emailAddr=$(echo $response | /usr/bin/awk -F'<email_address>|</email_address>' '{print $2}')


## method 2: Assume the email address is simply $userName@$mailDomain 
## THE USER OF THIS SCRIPT IS RESPONSIBLE FOR CORRECTLY SETTING $mailDomain
## mailDomain="pawneeparks.org"
# emailAddr="$userName@$mailDomain"


# this is a sanity test that recognizes 99% of email addresses. It will choke on
# some unusual formats like 'wontmatch@106.121.42.118' that are not commonly used (and
# probably should not be!) 
[[ "$emailAddr" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
rc=$?
if [ "$rc" != "0" ]
then
    echo "WARNING: [ $emailAddr ] _may_ be an invalid email address (looks dubious)"
fi

# mockbbinst runs and returns codes & messages like the bbinstaller app
#backblaze_installer="mockbbinst"
#backblaze_installer="$(which $backblaze_installer)" # grab the full address
#echo "backblaze_installer: $backblaze_installer"

#downloading the installer to the host machine
curl -0 https://secure.backblaze.com/mac/install_backblaze.dmg
#mounting the dmg 
hdiutil attach -quiet install_backblaze.dmg

# backblaze_installer="/Applications/Backblaze Installer.app/Contents/MacOS/bzinstall_mate"
backblaze_installer="/Volumes/Backblaze Installer/Backblaze Installer.app/Contents/MacOS/bzinstall_mate"
if ! [[ -e "$backblaze_installer" ]]
then
	echo "ERROR: file $backblaze_installer does not exist or is missing!"
	debugInfo
	diskutil unmount /Volumes/Backblaze\ Installer
	rm install_backblaze.dmg
	exit -10
else
	if  ! [[  -r "$backblaze_installer" ]]
	then
		echo "WARNING: user lacks read permission for file $backblaze_installer (may not be a fatal error)"
	fi
	if  ! [[ -x "$backblaze_installer" ]]
	then
		echo "ERROR: user lacks execute permission for file $backblaze_installer "
		debugInfo
		diskutil unmount /Volumes/Backblaze\ Installer
		rm install_backblaze.dmg
		exit -11
	fi
fi

#     Note the directory to which your Backblaze installer is installed can be specified within
# the policy, JAMF default for the policy is to run on boot drive

echo "RUNNING COMMAND: [ $backblaze_installer -nogui -createaccount $emailAddr none $backblaze_grpID $backblaze_grpToken ]"

#for historical reasons, the backblaze installer sends a success/error msg to stdout.

textReturn=$("$backblaze_installer" -nogui -createaccount $emailAddr none  $backblaze_grpID $backblaze_grpToken)

bbinstReturn="$?"

echo "textReturn: $textReturn"

# for historical reasons, the installer returns '1' on success.
if [[ $bbinstReturn -ne 1 ]]
then
	echo "ERROR: $backblaze_installer returned $bbinstReturn $textReturn "
	installerReturn=-12
    	debugInfo

else
	echo "Succeeded running Backblaze silent installer"
    	#echo "Success $bbinstReturn running [ $backblaze_installer ] as [ $textReturn ]"
    	installerReturn=0
fi

diskutil unmount /Volumes/Backblaze\ Installer
rm install_backblaze.dmg
exit $installerReturn