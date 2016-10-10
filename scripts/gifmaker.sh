#!/bin/bash

palette="/tmp/palette.png"
filters="fps=15,scale=480:-1:flags=lanczos"

file=$1
out=$2
ss=$3
t=$4

ffmpeg -ss $3 -t $4 -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -ss $3 -t $4 -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
