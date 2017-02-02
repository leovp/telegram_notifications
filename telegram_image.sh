#!/bin/bash
CHAT_ID='{YOUR_CHAT_ID}'
API_KEY='{YOUR_VERY_LONG_API_KEY}'

# Get the message from stdin.
MESSAGE=$(cat -)

# Create a temporary file for our image.
IMAGE=`tempfile -p telegram_image -s '.png'`

# Everything passed as arguments is our caption.
CAPTION="${@}"

# Prepare an image.
/bin/echo "${MESSAGE}" | /usr/bin/pbmtext -builtin fixed | /usr/bin/pnmtopng -compression 9 > "${IMAGE}"

# Try to send a message; sleep a bit after each unsuccessful attempt.
until /usr/bin/curl \
    -F "chat_id=${CHAT_ID}" \
    -F "caption=${CAPTION}" \
    -F "photo=@${IMAGE}" \
    "https://api.telegram.org/bot${API_KEY}/sendPhoto" >&/dev/null
do
    sleep 10
done

# Remove temporary files.
/bin/rm -f "${IMAGE}"
