oldvol=$(doas mixerctl outputs.master | tr ',' '\n' | tail -n 1)
newvol=$(echo "${oldvol}+$1" | bc)

doas mixerctl outputs.master=${newvol},${newvol}

echo "${newvol}"
