#!/bin/bash

usage(){
    echo -e "Usage:"
    echo -e "\t-f fps"
    echo -e "\t-i input_file"
    echo -e "\t-o output_file"
    echo -e "\t-s start_time"
    echo -e "\t-t duration"
    echo -e "\t-w width"
    echo -e "\t-r rotate"
}

function convert_it(){
    [[ -z $fps ]]&&fps=20
    [[ -z $width ]]&&width=320
    [[ -z $rotate ]]&&rotate=0
    [[ ! -z $start_time ]]&&ss="-ss ${start_time}"
    [[ ! -z $duration ]]&&t="-t ${duration}"

    palette="/tmp/palette.png"
    filters="transpose=${rotate},fps=${fps},scale=${width}:-1:flags=lanczos"
    
    echo -e "###### generating palatte ######"
    command1="ffmpeg $ss $t -i $input_file -vf "$filters,palettegen" $palette -y"
    echo -e running: ${command1}
    bash -c "${command1} &> /dev/null"
    echo -e "###### converting ######"
    command2="ffmpeg $ss $t -i $input_file -i $palette -lavfi \"$filters [x]; [x][1:v] paletteuse\" $output_file -y"
    echo -e "running: ${command2}"
    bash -c "${command2} &> /dev/null"
}

while getopts :f:w:r:s:t:o:i: OPTION
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
        r)
            rotate=${OPTARG}
            ;;
        \?)
            usage
            exit -1
            ;;
    esac
done
if [[ -z $input_file ]] || [[ -z $output_file ]];then
    usage
    exit -1
fi
convert_it && echo -e "DONE. output_file is ${output_file}"
