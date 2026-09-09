#!/bin/bash

# Port Binding for Render Free Tier
python3 -m http.server 8080 &

FILE_ID="18mJxKbzcZS2_H-7suWOFYTeW-Pk55nb-"

echo "=== STARTING VIDEO DOWNLOAD ==="
gdown --fuzzy "https://drive.google.com/uc?id=$FILE_ID" -O /app/video.mp4

if [ ! -f /app/video.mp4 ] || [ ! -s /app/video.mp4 ]; then
    gdown --id "$FILE_ID" -O /app/video.mp4 --remaining-ok
fi

echo "=== STARTING 24/7 TWITCH STREAM ==="

while true
do
  ffmpeg -re -stream_loop -1 -i /app/video.mp4 \
    -c:v libx264 -preset ultrafast -b:v 2000k -maxrate 2000k -bufsize 4000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://live.twitch.tv/app/$TWITCH_KEY"
  
  sleep 5
done
