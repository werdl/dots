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

import requests, re

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
    prev_song = title

    last_item = subprocess.check_output(["playerctl", "-l"]).decode("utf-8").strip().split("\n")[-1]

    try:
        artist, title = subprocess.check_output(
            ["playerctl", "metadata", "--format", "{{ artist }}%{{ title }}", "-p", last_item]
        ).decode("utf-8").strip().split("%", 1)
    except subprocess.CalledProcessError:
        title = "Idle"

    try:
        position = subprocess.check_output(
            ["playerctl", "position", "-p", last_item]
        ).decode("utf-8").strip()
    except subprocess.CalledProcessError:
        position = "0"

    calculated_start = int(time.time() - float(position))

    if artist=="":
        state = ActivityType.WATCHING # Set activity type to WATCHING if no artist is found

        img = show_thumb(title)

        RPC.update(
            state=title, 
            activity_type=ActivityType.WATCHING, 
            start=calculated_start,
            large_image=img if img else "default_image",
            large_text=title,
            name=f"{title} on Pipewire"
        )
    else:
        state = ActivityType.LISTENING


        if title != prev_song:
            img = get_thumbnail(title, artist)
        artist_thumb = get_artist_thumbnail(artist)



        RPC.update(
            state=title, 
            details=artist, 
            activity_type=ActivityType.LISTENING, 
            start=calculated_start,
            large_image=img if img else "default_image",
            large_text=artist,
            small_image=artist_thumb if artist_thumb else "default_image",
            small_text=title,
            name=f"{title} on Pipewire"
        )

    time.sleep(15)

