#!/usr/bin/env sh

# Argument 1 = number of seconds to wait
while [ 1=1 ]; do
    find -L ~/Pictures/wallpapers -type f \( -name '*.jpg' -o -name '*.png' \) -size +500k -print0 | shuf -n1 -z | xargs -0 feh --bg-scale
    sleep $1
done
