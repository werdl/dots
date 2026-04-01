#!/bin/bash

players=$(playerctl -l 2>/dev/null)

player_lockfile="/home/werdl/.config/sway/playerctl-lockfile"

# check if any players are actively playing
for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" == "Playing" ]; then
        echo "$player" | tee "$player_lockfile"
        exit 0
    fi
done

# if there is a lockfile, check if that player still exists (even if not playing)
if [ -f "$player_lockfile" ]; then
    locked_player=$(cat "$player_lockfile")
    if echo "$players" | grep -q "^$locked_player$"; then
        echo "$locked_player"
        exit 0
    else
        rm "$player_lockfile"
    fi
fi

# else, return the first available player, if any
if [ -n "$players" ]; then
    first_player=$(echo "$players" | head -n 1)
    echo "$first_player"
    exit 0
fi
