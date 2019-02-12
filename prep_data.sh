#!/bin/bash
subjects=$1
data_dir=$2

echo "Start preparing the data!"
echo "Source file: $1"
echo "Data Directory: $2"

for i in $( cat $subjects ); do
    if [ ! -d $data_dir/$i ]; then
        echo "Error: Suject $i does not exist!"
    fi
done