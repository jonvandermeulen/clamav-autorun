#!/bin/bash
function notifier_action {
	read action
	if [ "$action" = "View Log" ]; then
		open /Applications/Utilities/Console.app /var/log/system.log
	fi
}

terminal-notifier -title "Title" -message "Message" -actions "View Log" -execute "open ~/" | notifier_action