#!/bin/bash
function showNotification {
	terminal-notifier -title "ClamAV" -message "$1" -subtitle "$2" -sender "com.Apple.Console" -closeLabel "Dismiss" -actions "View Log" -execute "open /Applications/Utilities/Console.app /usr/local/etc/clamav/clamscan.log & exit" | notifier_action &
}
function showNotificationWithInterupt {
	terminal-notifier -title "ClamAV" -message "$1" -subtitle "$2" -sender "com.Apple.Console" -closeLabel "Dismiss" -actions "Abort Scan" -execute "open /Applications/Utilities/Console.app /usr/local/etc/clamav/clamscan.log & exit" | notifier_action &
}
function kill_proc {
	kill $(ps aux | awk '/[f]reshclam/ {print $2}') 2> /dev/null & kill $(ps aux | awk '/[c]lamscan/ {print $2}') 2> /dev/null & exit
}
function exit_trap {
	date +"Scan Aborted: %Y-%m-%dT%H:%M:%S" && showNotification "Scan Aborted" && kill_proc & exit
}
function notifier_action {
	read a
	if [ "$a" = "Abort Scan" ]; then
		exit_trap & exit 1
	elif [ "$a" = "View Log" ]; then
		open /Applications/Utilities/Console.app /usr/local/etc/clamav/clamscan.log
	fi
}
trap exit_trap SIGINT SIGTERM SIGKILL

showNotificationWithInterupt "Virus Scan Started"
echo "-------------------------------------------------------------------------------"
freshclam
scanresult=$?
if [ $scanresult != 0 ]; then
	showNotificationWithInterupt "Scanning with the old ones..." "Error updating virus definitions!"
fi
date +"Scan Start: %Y-%m-%dT%H:%M:%S"

while read -r line; do
	echo $line; [[ $line == *FOUND ]] && ((found++))
done < <(clamscan -i -r /) &&

date +"Scan Complete: %Y-%m-%dT%H:%M:%S"

if [[ $found == "" ]]; then
	showNotification "No Threats found." "Scan Complete"
elif [ $found \> 0 ]; then
	showNotification "View log at /usr/local/etc/clamav/clamscan.log for details." "$found THREAT(S) DETECTED."
fi
exit 0
