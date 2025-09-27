
date="$(date +'%Y-%m-%d_%H-%M-%S')"

touch "/home/werdl/Pictures/Screenshots/$date.png"

grim -g "$(slurp)" - | tee "/home/werdl/Pictures/Screenshots/$date.png" | wl-copy
