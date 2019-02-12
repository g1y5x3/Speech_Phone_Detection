#!/bin/bash
# Example
# ./prep_data.sh <subjects file> <wave file dir> <sentence label file> <output dir>
subjects=$1
data_wav_dir=$2
label=$( cat $3 )
data_out_dir=$4

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
        echo "$utt_id $filename" >> $data_out_dir/wav.scp
        echo "$utt_id $label" >> $data_out_dir/text
        echo "$utt_id $i" >> $data_out_dir/utt2spk
    done
done

echo "Successfully created files for $1!"