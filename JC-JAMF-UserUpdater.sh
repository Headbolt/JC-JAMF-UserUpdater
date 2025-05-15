#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	JC-JAMF-UserUpdater.sh
#	https://github.com/Headbolt/JC-JAMF-UserUpdater
#
#   This Script is designed for use in JAMF and was designed to Grab the current users UPN from JAMF Connect.
#	and upload it to the Compiter Onect as the "User"

#	This Will require the follow options to be enabled in. Settings > Computer Management > Inventory Collection.
#
#	"Allow local administrators to use the jamf binary recon verb to change User and Location inventory information in Jamf Pro"
#	"Collect user and location information from Directory Service"
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 15/05/2025
#
#	15/05/2025 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
ScriptVer=v1.0
#
sleep 90 # Pausing before data gathering incase Policy runs at first time login, to allow everything to settle
#
CurrentUser=$(stat -f%Su /dev/console) # Grab Current Username
# Grab JAMF Connect State for Current User
JCdisplayName=$(sudo -u "$CurrentUser" defaults read "/Users/$CurrentUser/Library/Preferences/com.jamf.connect.state" DisplayName 2>/dev/null)
#
ScriptName="MacOS | Update Computer with Current User | Global" # Sets Script Name
ExitCode=0 # Sets Default Exit Code as successful
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Script Start Function
#
ScriptStart(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
/bin/echo Starting Script '"'$ScriptName'"'
/bin/echo Script Version '"'$ScriptVer'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
exit $ExitCode # Exit with the relevant Exit Code
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
ScriptStart
#
if [[ -n "$JCdisplayName" ]]
	then
		/bin/echo 'Current User is "'$CurrentUser'"'
		/bin/echo 'Current Users JAMF Connect Display Name is "'$JCdisplayName'"'
		SectionEnd
		/bin/echo 'Pushing "'$JCdisplayName'" Onto JAMF Record for this Computer'
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		/bin/echo 'Running Command "'/usr/local/bin/jamf recon -skipApps -skipFonts -skipPlugins -endUsername $JCdisplayName'"'
		SectionEnd
        /usr/local/bin/jamf recon -skipApps -skipFonts -skipPlugins -endUsername $JCdisplayName
	else
		/bin/echo 'Current Users JAMF Connect Display Name is Not Found'
fi
#
SectionEnd
ScriptEnd
