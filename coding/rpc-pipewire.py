from pypresence import Presence
import time
import subprocess

from pypresence.types import ActivityType, StatusDisplayType
import ytmusicapi

def get_thumbnail(song, artist):
    ytmusic = ytmusicapi.YTMusic()
    search_results = ytmusic.search(f"{song} {artist}", filter="songs")
    if search_results:
        thumbnails = search_results[0].get("thumbnails", [])
        if thumbnails:
            return thumbnails[-1]["url"]
    return None

def get_artist_thumbnail(artist):
    ytmusic = ytmusicapi.YTMusic()
    search_results = ytmusic.search(artist, filter="artists")
    if search_results:
        thumbnails = search_results[0].get("thumbnails", [])
        if thumbnails:
            return thumbnails[-1]["url"]
    return None

CLIENT_ID = "1430932134016581752"
RPC = Presence(CLIENT_ID)
RPC.connect()

print(get_artist_thumbnail("metallica"))

title = ""

import requests, re, os

def clean_title(s: str) -> str:
    s = re.sub(r'\([^)]*\)|\[[^\]]*\]', '', s)
    words = s.split()
    words = [w for w in words if re.fullmatch(r'[A-Za-z]+', w)]
    return ' '.join(words).strip()

def show_thumb(name: str):
    name = clean_title(name)
    r = requests.get("https://api.tvmaze.com/singlesearch/shows", params={"q": name})
    r.raise_for_status()
    data = r.json()
    return data.get("image", {}).get("medium")

img = None

while True:
    time.sleep(1)
    prev_song = title

    if not os.path.exists("/home/werdl/.config/sway/playerctl-lockfile"):
        # remove activity if no player is running
        RPC.clear()

    with open("/home/werdl/.config/sway/playerctl-lockfile") as f:
        last_item = f.read().strip()
        print(last_item)

    try:
        length, artist, title, album, img = subprocess.check_output(
            ["playerctl", "metadata", "--format", "{{ mpris:length }}%{{ artist }}%{{ title }}%{{ album }}%{{ mpris:artUrl }}", "-p", last_item]
        ).decode("utf-8").strip().split("%", 5)
    except subprocess.CalledProcessError:
        title = "Idle" 

    try:
        url = subprocess.check_output(
            ["playerctl", "metadata", "--format", "{{ xesam:url }}", "-p", last_item]
        ).decode("utf-8").strip()
    except subprocess.CalledProcessError:
        url = ""

    try:
        position = subprocess.check_output(
            ["playerctl", "position", "-p", last_item]
        ).decode("utf-8").strip()
        print(position)
    except subprocess.CalledProcessError:
        position = "0"
    
    calculated_start = int(time.time() - float(position))
    try:    
        calculated_end = calculated_start + int(float(length)/1e6)
    except ValueError:
        calculated_end = None

    if title==prev_song:
        continue

    print("new song baby")

    if artist=="":
        state = ActivityType.WATCHING # Set activity type to WATCHING if no artist is found

        RPC.update(
            state=title, 
            activity_type=ActivityType.WATCHING, 
            start=calculated_start,
            end=calculated_end,
            large_image=img.replace("file://", "") if img else "default_image",
            large_text=title,
            name=f"{title} on Pipewire"
        )
    else:
        state = ActivityType.LISTENING


        if title != prev_song:
            generated_img = get_thumbnail(title, artist)
            
            if not generated_img:
                generated_img = img.replace("file://", "") if img else "default_image"

            artist_thumb = get_artist_thumbnail(artist)


        album = album if album else title

        RPC.update(
            state=artist, 
            name=title, 
            #details=album,
            activity_type=ActivityType.LISTENING, 
            start=calculated_start,
            end=calculated_end,
            large_image=generated_img,
            large_text=album,
            small_image=artist_thumb if artist_thumb else "default_image",
            small_text=artist,
        )
