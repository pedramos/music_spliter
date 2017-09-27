#!/bin/bash

# This script is used to split a music file based on a txt file
# USAGE split.sh <original file> <split parameters> 
#AUTHOR: PEDRO L. RAMOS (RAMI)
help_message(){
		echo "
	-s=<split_file> | --split=<split_file>
	-m=<music_file> | --music=<music_file>
	-d=<out_dir>	| --dir=<out_dir>
	-h | --help : this help message
	"
	exit

}


if [ -z "$1" ]; then

		help_message
fi

for i in "$@"
do
case $i in
    -s=*|--split=*)
    input=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`

    ;;
    -m=*|--music=*)
    bigfile=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    -d=*|--dir=*)
    dir=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
	dir="${dir/#\~/$HOME}"
    ;;
    -h=*|--help=*)
    help_message 
    ;;
    *)
            echo "what!?"; exit
    ;;
esac
done

if [ ! -d "$dir" ]; then
		mkdir "$dir"
fi

ext=$(echo $bigfile | awk -F. '{printf ".%s", $NF}')


ant=''
while IFS= read -r i
do
		name=$(echo $ant | cut -d'-' -f2 | xargs )
		startt=$(echo $ant|cut -d'-' -f1|  xargs)
		end=$(echo $i|cut -d'-' -f1| xargs)

		if test -n "$ant"; then
				
				echo ffmpeg  -loglevel error -i "$bigfile" -vn -acodec copy -ss "$startt" -to "$end" "$dir"/"$name""$ext"

		
				 < /dev/null ffmpeg  -loglevel error -i "$bigfile" -vn -acodec copy -ss "$startt" -to "$end" "$dir"/"$name""$ext"
		fi
		ant=$(echo $i)

done < "$input"

