muted=$(doas mixerctl outputs.master.mute | tr '=' '\n' | tail -n 1)

if [ "$muted" == "off" ]; then
    new="on"
else
    new="off"
fi

doas mixerctl "outputs.master.mute=${new}"
