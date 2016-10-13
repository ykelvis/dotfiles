#!/bin/bash

palette="/tmp/palette.png"
filters="fps=25,scale=480:-1:flags=lanczos"

file=$1
out=$2
[[ $3 != "" ]]&&ss="-ss ${3}"
[[ $4 != "" ]]&&t="-t ${4}"

ffmpeg $ss $t -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg $ss $t -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
