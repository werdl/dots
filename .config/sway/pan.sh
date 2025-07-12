oldvol_l=$(doas mixerctl outputs.master | tr ',' '\n' | head -n 1 | tr '=' '\n' | tail -n 1)
oldvol_r=$(doas mixerctl outputs.master | tr ',' '\n' | tail -n 1)
newvol_l=$(echo ${oldvol_l}+$1 | bc)
newvol_r=$(echo ${oldvol_r}- $1 | bc)

echo "${oldvol_l},${oldvol_r}"

doas mixerctl "outputs.master=${newvol_l},${newvol_r}"


echo "${newvol}"
