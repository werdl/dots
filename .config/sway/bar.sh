#!/bin/sh
set -x
/home/werdl/.config/sway/stat.sh &

acstatus=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}' | sed 's/-/ /g')
percent=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')
cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.1f%\n", 100 - $1}')
temp=$(sensors | grep temp | head -n 9 | awk '{print $2}' | cut -c2-5 | sed ':a;N;$!ba;s/\n/ /g' | awk '{s=0; for(i=1;i<=NF;i++) s+=$i; print s/NF}' | awk '{printf "%.1f\n", $1}')
date=$(date +"%H:%M:%S %d/%m/%Y")
netname=$(nmcli | head -n 1)
ram=$(free -h | head -n 2 | tail -n 1 | awk '{print $3,"/",$6}')
audio=$(amixer get Master | grep % | awk '{print $4}' | cut -c2- | rev | cut -c2- | rev)
host="$(uname) $(uname -r) on $(arch)"
mute="mute $(amixer get Master | grep '\[off\]' > /dev/null && echo "on" || echo "off")"
songname=$(playerctl metadata title)
status=$(playerctl status)
artist=$(playerctl metadata artist)

if [ "$songname" != "" ]; then
    echo "${status}: ${songname} (${artist}) | ${host} | ${acstatus}, ${percent} | ${cpu}, ${temp}°C | ${ram} | ${audio}, ${mute} | ${netname} | ${date}"
else
    echo "${host} | ${acstatus}, ${percent} | ${cpu}, ${temp}°C | ${ram} | ${audio}, ${mute} | ${netname} | ${date}"

fi
