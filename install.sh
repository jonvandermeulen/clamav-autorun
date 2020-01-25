#!/bin/bash
NOTIFIER="$(brew ls | grep terminal-notifier)"
if [ "$NOTIFIER" == "" ]; then
    read -p "terminal-notifier not found. Install now? (y/N) " inst
    case "$inst" in
        [Yy] | [Yy][Ee][Ss] ) brew install terminal-notifier ;;
        *) echo "Fine. Be that way." && exit 3 ;;
    esac
fi

echo "Copying clamscan.sh"
cp clamscan.sh /usr/local/etc/clamav/clamscan.sh
echo "Making clamscan.sh executable"
chmod 0700 /usr/local/etc/clamav/clamscan.sh
echo "Copying plist"
cp local.clamscan.plist ~/Library/LaunchAgents/local.clamscan.plist
echo "(Re)loading launch agent"
launchctl unload ~/Library/LaunchAgents/local.clamscan.plist 2> /dev/null && launchctl load ~/Library/LaunchAgents/local.clamscan.plist

echo "Install successful"
read  -p "Start scan now? (y/N) " start_scan
case "$start_scan" in
    [Yy] | [Yy][Ee][Ss] ) launchctl start local.clamscan && exit ;;
    *) exit 3;;
esac

