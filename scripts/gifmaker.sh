#!/bin/bash

usage(){
    printf "Usage:\n-f fps\n-i input_file\n-o output_file\n-s start_time\n-t duration\n-w width\n"
}

function convertit(){
    [[ $fps == '' ]]&&fps=20
    [[ $width == '' ]]&&width=320
    [[ $start_time != "" ]]&&ss="-ss ${start_time}"
    [[ $duration != "" ]]&&t="-t ${duration}"
    
    palette="/tmp/palette.png"
    filters="fps=$fps,scale=$width:-1:flags=lanczos"
    
    printf "#\n#\n#\n#\n#\n#\n"
    echo running: ffmpeg $ss $t -i $input_file -vf "$filters,palettegen" -y $palette
    ffmpeg $ss $t -i $input_file -vf "$filters,palettegen" -y $palette
    printf "#\n#\n#\n#\n#\n#\n"
    echo running: ffmpeg $ss $t -i $input_file -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $output_file
    ffmpeg $ss $t -i $input_file -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $output_file
}

while getopts :f:w:s:t:o:i: OPTION
do
    case $OPTION in
        i)
            input_file=${OPTARG}
            ;;
        o)
            output_file=${OPTARG}
            ;;
        s)
            start_time=${OPTARG}
            ;;
        t)
            duration=${OPTARG}
            ;;
        f)
            fps=${OPTARG}
            ;;
        w)
            width=${OPTARG}
            ;;
        \?)
            usage
            exit -1
            ;;
    esac
done
if [[ $input_file == '' ]] || [[ 'output_file' == '' ]];then
    usage
    exit -1
fi
convertit
