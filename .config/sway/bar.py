#!/usr/bin/env python3
import json, subprocess, time, sys

print(json.dumps({"version":1,"click_events":True}))
print("[")
sys.stdout.flush()

def sh(cmd):
    return subprocess.check_output(cmd, shell=True, text=True).strip()

def click_reader():
    buf = ""
    while True:
        chunk = sys.stdin.read(1)
        if not chunk:
            break
        if chunk == '{':
            buf = '{'
        elif buf:
            buf += chunk
            if chunk == '}':
                try:
                    evt = json.loads(buf)
                    handle_click(evt)
                except:
                    pass
                buf = ""

pavucontrol_opened = False
nmtui_opened = False
gsimplecal_opened = False
fastfetch_opened = False
btop_opened = False

def handle_click(evt):
    name = evt.get("name")
    btn  = evt.get("button")

    if name == "audio" and btn == 1:
        global pavucontrol_opened
        if not pavucontrol_opened:
            pavucontrol_opened = True
            subprocess.Popen(["pavucontrol", "-t", "3"])
        else:
            pavucontrol_opened = False
            subprocess.Popen(["pkill", "pavucontrol"])

    elif name == "net" and btn == 1:
        global nmtui_opened
        if not nmtui_opened:
            nmtui_opened = True
            subprocess.Popen(["networkmanager_dmenu"])
        else:
            nmtui_opened = False
            subprocess.Popen(["pkill", "rofi"])

    elif name=="date" and btn==1:
        global gsimplecal_opened
        if not gsimplecal_opened:
            gsimplecal_opened = True
            subprocess.Popen(["gsimplecal"])
        else:
            gsimplecal_opened = False
            subprocess.Popen(["pkill", "gsimplecal"])

    elif name=="host" and btn==1:
        global fastfetch_opened
        if not fastfetch_opened:
            fastfetch_opened = True
            subprocess.Popen(["foot", "--app-id", "floating", "-H", "-w", "1000x450", "fastfetch"])
        else:
            fastfetch_opened = False
            subprocess.Popen(["pkill", "-f", "foot --app-id floating"])

    elif name in ["cpu", "temp", "ram"] and btn==1:
        global btop_opened
        if not btop_opened:
            btop_opened = True
            subprocess.Popen(["foot", "--app-id", "floating", "-w", "1000x600", "btop", "-p", "2"])
        else:
            btop_opened = False
            subprocess.Popen(["pkill", "-f", "foot --app-id floating"])

import threading
threading.Thread(target=click_reader, daemon=True).start()

while True:
    try:
        ac = sh("upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/{print $2}'")
        pct = sh("upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/{print $2}'")
        host = sh("printf '%s %s on %s' \"$(uname)\" \"$(uname -r)\" \"$(arch)\"")
        net = sh("nmcli | head -n1")
        ram = sh("free -h | awk 'NR==2{print $3\"/\"$6}'")
        audio = sh("wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}'")
        mute = sh("wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($3 ? \"on\" : \"off\")}'")
        date = time.strftime("%H:%M:%S %d/%m/%Y")

        # cpu
        with open("/proc/stat") as f: l1=f.readline().split()[1:8]
        t1=sum(map(int,l1)); i1=int(l1[3])+int(l1[4])
        time.sleep(0.3)
        with open("/proc/stat") as f: l2=f.readline().split()[1:8]
        t2=sum(map(int,l2)); i2=int(l2[3])+int(l2[4])
        dt=t2-t1; di=i2-i1
        cpu=f"{(100*(dt-di)/dt):.1f}%"

        # temp
        thermals = sh("ls /sys/class/thermal/thermal_zone*/temp").splitlines()
        temps = []
        for zone in thermals:
            with open(zone) as f:
                try:
                    temp_millic = int(f.read().strip())
                except OSError:
                    continue
                temps.append(temp_millic / 1000.0)
        temp = sum(temps)/len(temps)
        # music
        try:
            p = sh("/home/werdl/.config/sway/get_active.sh")
            song = sh(f"playerctl metadata title -p {p}")
            artist = None
            try:
                artist = sh(f"playerctl metadata artist -p {p}")
            except subprocess.CalledProcessError:
                pass
            st = sh(f"playerctl status -p {p}")
            music=f"{st}: {song} {'('+artist+')' if artist else ''}"
        except:
            music=""

        blk=[
            {"name":"music","full_text":music},
            {"name":"host","full_text":host},
            {"name":"bat","full_text":f"{ac}, {pct}"},
            {"name":"cpu","full_text":cpu},
            {"name":"temp","full_text":f"{temp:.1f}°C"},
            {"name":"ram","full_text":ram},
            {"name":"audio","full_text":f"{audio}%, mute {mute}"},
            {"name":"net","full_text":net},
            {"name":"date","full_text":date}
        ]

        print(json.dumps(blk)+",")
        sys.stdout.flush()
        time.sleep(0.4)

    except KeyboardInterrupt:
        break

