#!/bin/bash

# Port Binding for Render
python3 -m http.server 8080 &
python3 /app/bot.py &

FILE_ID="18mJxKbzcZS2_H-7suWOFYTeW-Pk55nb-"

echo "=== STARTING VIDEO DOWNLOAD ==="

# Try gdown
gdown "https://drive.google.com/uc?id=${FILE_ID}&confirm=t" -O /app/video.mp4 --fuzzy

# Fallback download using curl if gdown fails
if [ ! -f /app/video.mp4 ] || [ ! -s /app/video.mp4 ]; then
    echo "gdown failed, trying curl..."
    curl -L -c /tmp/cookies.txt "https://docs.google.com/uc?export=download&id=${FILE_ID}" > /tmp/confirm.html
    CONFIRM=$(grep -o 'confirm=[^&]*' /tmp/confirm.html | head -n 1)
    curl -L -b /tmp/cookies.txt "https://docs.google.com/uc?export=download&id=${FILE_ID}&${CONFIRM}" -o /app/video.mp4
fi

# Verify Download
if [ ! -f /app/video.mp4 ] || [ ! -s /app/video.mp4 ]; then
    echo "❌ ERROR: Video file download failed! Check Google Drive Link permissions."
    exit 1
fi

echo "✅ Download Success! Starting 24/7 Twitch Stream..."

while true
do
  ffmpeg -re -stream_loop -1 -i /app/video.mp4 \
    -c:v libx264 -preset ultrafast -b:v 2000k -maxrate 2000k -bufsize 4000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://live.twitch.tv/app/$TWITCH_KEY"
  
  sleep 5
done
