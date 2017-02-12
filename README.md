# System Notifications via Telegram
A couple of scripts for your notification needs.

## Basics
The two scripts are almost identical in their purpose: they read text stdin and send you a Telegram message.


**telegram_text.sh** sends everything as is, except it makes the very first line bold (I found it helpful and pretty).  
Example:
```
cat /etc/motd | ./telegram_text.sh
```
**telegram_image.sh** converts text into an image (using a nice looking monospaced font) and sends it as an inline photo. Additionally this script uses commandline arguments as a caption for the image.  
Example:
```
cat /etc/motd | ./telegram_image.sh "motd from $(hostname)"
```

## Prerequisites
- [Create a Telegram bot](https://core.telegram.org/bots#6-botfather) — you'll need an API_KEY and a CHAT_ID.
- **curl** [both scripts] — for sending API requests.
- **netpbm** [telegram_image only] — for generating images from text.
- **tempfile** [telegram_image only] — comes from debianutils on my system; I hope there are equivalents elsewhere.

## Caveats
- These scripts are not very flexible; hopefully nothing breaks in a foreseeable future.
- **pbmtext**, which is part of **netpbm** package, doesn't support multibyte encodings at all. Moreover, the default monospaced font supports only 7-bit ASCII.  
You have two options:
  * Use only 7-bit ASCII in your notification messages. English locale works excellent.
  * Find and download an 8-bit font (BDF or PBM only) for your encoding of choice, for example KOI8-R.  
  Replace `pbmtext -builtin fixed` with `pbmtext -font /path/to/font`
- The scripts are going to try to send messages until success (as reported by curl). So, indefinitely in the worst-case scenario.

## Usage examples
### smartmontools
  1. Create a link to telegram_text.sh in /etc/smartmontools/run.d:  
  ```
  ln -s /opt/notification-scripts/telegram_text.sh /etc/smartmontools/run.d/10telegram
  ```
  2. Make sure you have a "-M" command in /etc/smartd.conf; something like this:  
  ```
  DEVICESCAN -d removable -m root -a -M exec /usr/share/smartmontools/smartd-runner
  ```
  3. Now you'll receive warnings from smartd via Telegram!

### ZFS Event Daemon  
This method is even cooler. We will change a mailer program, so ZED would just send an email as always, but it's going to end up in your Telegram messages.
  1. Open /etc/zfs/zed.d/zed.rc
  2. Set ZED_EMAIL_PROG to the path of your script of choice.  
  ```
  ZED_EMAIL_PROG="/opt/notification-scripts/telegram_image.sh"
  ```
  3. Optionally change ZED_EMAIL_OPTS, so that the image is sent with a caption.  
  ```
  ZED_EMAIL_OPTS="#zfs #$(hostname)"
  ```
  I chose to use hashtags, it really simplifies searching for messages from different hosts and daemons.
  