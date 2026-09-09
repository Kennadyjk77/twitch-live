import socket
import time
import os

BOT_USERNAME = os.getenv("BOT_USERNAME")
OAUTH_TOKEN = os.getenv("TWITCH_OAUTH")

# Unga சொந்த messages-ah inge type pannikonga
MESSAGES = [
    "Welcome guys! Channel-ah Follow panna marakkadhinga! ❤️",
    "Stream-ah enjoy pannunga, drop your comments! 🎵",
    "Thanks for watching 24/7 Stream! 🔥
    "Website la Live Pakka VPN MUST 💜
    "Website Link! https://jkmedia.unaux.com/bigg-boss-tamil-season-10/?i=1
    "WhatsApp Group! https://chat.whatsapp.com/CQdKVrZHA8oLjasVnisgoD?s=cl&p=a&mlu=4&ilr=4
]

# Ovvoru message-kum edaiyil ulla idavelai (Seconds-il) -> 60 = 1 Mins
INTERVAL = 60 

def run_bot():
    if not BOT_USERNAME or not OAUTH_TOKEN:
        print("❌ Bot Error: BOT_USERNAME or TWITCH_OAUTH missing!")
        return

    server = 'irc.chat.twitch.tv'
    port = 6667

    try:
        sock = socket.socket()
        sock.connect((server, port))
        sock.send(f"PASS {OAUTH_TOKEN}\r\n".encode('utf-8'))
        sock.send(f"NICK {BOT_USERNAME.lower()}\r\n".encode('utf-8'))
        sock.send(f"JOIN #{BOT_USERNAME.lower()}\r\n".encode('utf-8'))
        print("✅ Connected to Twitch Chat!")

        index = 0
        while True:
            msg = MESSAGES[index % len(MESSAGES)]
            sock.send(f"PRIVMSG #{BOT_USERNAME.lower()} :{msg}\r\n".encode('utf-8'))
            print(f"🤖 Auto Message Sent: {msg}")
            index += 1
            time.sleep(INTERVAL)

    except Exception as e:
        print(f"❌ Chat Bot Error: {e}")

if __name__ == "__main__":
    time.sleep(15)
    run_bot()
