# ClamAV Background Service #

## Prerequisites ##
1. ClamAV installed per [these instructions](http://exc-mcoe-cs01.cloudapp.net/mcoewiki/index.php/ClamAV).
2. `brew install terminal-notifier`

## How it works ##
`clamscan.sh` is a bash script that will run `freshclam` to update virus definitions, then `clamscan` with options to only display infected files. The script will post notifications when the scan begins and ends (and will notify if viruses are found or if errors occur).

`local.clamscan.plist` is a Local Agent configuration file that will execute `clamscan.sh` on a schedule. It is configured to give the service a low priority, so it may run in the background without degrading performance appreciably. As configured, this service will run Mon-Wed-Fri whenever it feels like it (probably when you boot up in the morning).

## Installation ##

Run the install.sh script
```
bash install.sh
```

If that fails, the manual steps are below:

Copy `clamscan.sh` to the ClamAV Configuration directory, and make it executable
```
cp clamscan.sh /usr/local/etc/clamav/clamscan.sh
chmod 0700 /usr/local/etc/clamav/clamscan.sh
```

Copy `local.clamscan.plist` to the LocalAgents folder and load it.
```
cp local.clamscan.plist ~/Library/LaunchAgents/local.clamscan.plist
launchctl load ~/Library/LaunchAgents/local.clamscan.plist
```

## To start a scan manually ##
```
launchctl start local.clamscan
```