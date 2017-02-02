#!/bin/bash
CHAT_ID='{YOUR_CHAT_ID}'
API_KEY='{YOUR_VERY_LONG_API_KEY}'

# Get the message from stdin, making the first line bold.
MESSAGE=$(cat - | sed '1s/\(.*\)/*\1*/')

# Try to send a message; sleep a bit after each unsuccessful attempt.
until /usr/bin/curl -G \
    --data-urlencode "parse_mode=Markdown" \
    --data-urlencode "chat_id=${CHAT_ID}" \
    --data-urlencode "text=${MESSAGE}" \
    "https://api.telegram.org/bot${API_KEY}/sendMessage" >&/dev/null
do
    sleep 10
done
