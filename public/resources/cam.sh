#!/bin/bash

in_dir="/storage/emulated/0/DCIM/Camera/"
out_dir="/home/a/code/quatloo/static/images/"

files=$(adb shell ls $in_dir | grep IMG | sort -h | tail -n $1)

for file in $files; do

    # Pull the file from phone and pipe it to ImageMagick's convert command
    adb exec-out cat "$in_dir$file" | convert - -resize 1200x800 "$out_dir$file"
done

