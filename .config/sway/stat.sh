echo "100-$(vmstat 1 2 | rev | awk '{print $1}' | rev | tail -n 1)" | bc >> /home/werdl/.config/sway/stat
