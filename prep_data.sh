#!/bin/bash
subjects=$1
data_wav_dir=$2
data_out_dir=$3

echo "Start preparing the data!"
echo "Source file: $1"
echo "Data Directory: $2"

for i in $( cat $subjects ); do
    # Check whether the directory exists for 
    # target subject
    if [ ! -d $data_wav_dir/$i ]; then
        echo "Error: Suject $i does not exist!"
        exit
    fi

    # Extract file list from the directory
    for j in $( ls -1 $data_wav_dir/$i ); do
        # Prepare wav.scp
        utt_id=$i'_'$j
        utt_id=${utt_id%%.*}
        filename=`pwd`/$data_wav_dir/$i/$j
        echo "$utt_id $filename" >> wav.scp
    done

done