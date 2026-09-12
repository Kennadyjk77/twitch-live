#!/bin/bash

# Port Binding for Render Web Service
python3 -m http.server 8080 &
python3 /app/bot.py &

# Unga M3U8 Live Stream Link
STREAM_URL="https://newcdn.tamils.click/live1channel/tracks-v1a1/mono.ts.m3u8"

echo "=== STARTING AUTOMATIC M3U8 RESTREAM TO TWITCH ==="

while true
do
  ffmpeg -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "$STREAM_URL" \
    -c:v libx264 -preset ultrafast -b:v 2000k -maxrate 2000k -bufsize 4000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://live.twitch.tv/app/$TWITCH_KEY"
  
  echo "Stream disconnect aanaal 5 seconds-il automatic-a reconnect aagum..."
  sleep 5
done
