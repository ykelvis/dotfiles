#!/bin/bash

files=("$@")
first=${files[0]}

for i in ${files[@]}; do
    convert -scale 1280x720 $i ${i%%.jpg}-720.jpg
done

unset files[0]

for i in ${files[@]}; do
    convert -gravity southwest -crop 1280x110+0+0 ${i%%.jpg}-720.jpg ${i%%.jpg}-crop.jpg
done

for i in ${files[@]}; do
    convert -append ${first%%.jpg}-720.jpg ${i%%.jpg}-crop.jpg ${first%%.jpg}-720.jpg
done

mv ${first%%.jpg}-720.jpg output.jpg

for i in ${files[@]}; do
    rm ${i%%.jpg}-720.jpg ${i%%.jpg}-crop.jpg
done
