#!/bin/bash
# Get all core temps from `sensors`, remove special characters, and calculate the average
total=0
count=0
for temp in $(sensors | grep -oP 'Core \d+: +\+\K\d+\.\d+'); do
    total=$(echo "$total + $temp" | bc)
    count=$((count + 1))
done

if [ "$count" -gt 0 ]; then
    avg=$(echo "$total / $count" | bc -l | awk '{printf "%.1f", $0}')
    echo "$avg°C"
else
    # Fallback to package temp if cores aren't read properly
    sensors | grep -oP 'Package id \d+: +\+\K\d+\.\d+'
fi

