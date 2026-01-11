#!/bin/sh
set -x
/home/werdl/.config/sway/stat.sh &

acstatus=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}' | sed 's/-/ /g')
percent=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}')
cpu=$(read c u n s i w x y z < /proc/stat; t1=$((u+n+s+i+w+x+y)); i1=$((i+w)); sleep 0.3; read c u n s i w x y z < /proc/stat; t2=$((u+n+s+i+w+x+y)); i2=$((i+w)); dt=$((t2-t1)); di=$((i2-i1)); usage=$(echo "scale=1; (100*($dt-$di)/$dt)" | bc); printf "%04.1f" "$usage")
temp=$(sensors | grep temp | head -n 9 | awk '{print $2}' | cut -c2-5 | sed ':a;N;$!ba;s/\n/ /g' | awk '{s=0; for(i=1;i<=NF;i++) s+=$i; print s/NF}' | awk '{printf "%.1f\n", $1}')
netname=$(nmcli | head -n 1)
ram=$(free -h | head -n 2 | tail -n 1 | awk '{print $3,"/",$6}')
audio=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}')
host="$(uname) $(uname -r) on $(arch)"
mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($3 ? "on" : "off")}')
songname=$(playerctl metadata title)
status=$(playerctl status)
artist=$(playerctl metadata artist)

date=$(date +"%H:%M:%S %d/%m/%Y")

if [ "$songname" != "" ]; then
    echo "${status}: ${songname} (${artist}) | ${host} | ${acstatus}, ${percent} | ${cpu}%, ${temp}°C | ${ram} | ${audio}%, mute ${mute} | ${netname} | ${date}"
else
    echo "${host} | ${acstatus}, ${percent} | ${cpu}%, ${temp}°C | ${ram} | ${audio}%, mute ${mute} | ${netname} | ${date}"

fi
