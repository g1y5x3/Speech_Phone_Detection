#!/bin/bash
. ./path.sh || exit 1
. ./cmd.sh || exit 1
nj=1       # number of parallel jobs - 1 is perfect for such a small data set
lm_order=2 # language model order (n-gram quantity)
# Safety mechanism (possible running this script with modified arguments)
. utils/parse_options.sh || exit 1
[[ $# -ge 1 ]] && { echo "Wrong arguments!"; exit 1; }
# Removing previously created data (from last run.sh execution)
rm -rf exp mfcc data/train/spk2utt data/train/cmvn.scp data/train/feats.scp data/train/split1 data/test/spk2utt data/test/cmvn.scp data/test/feats.scp data/test/split1 data/local/lang data/lang data/local/tmp data/local/dict/lexiconp.txt

echo
echo "===== PREPARING ACOUSTIC DATA ====="
echo
# Needs to be prepared by hand (or using self written scripts):
#
# wav.scp     [<uterranceID> <full_path_to_audio_file>]
# text        [<uterranceID> <text_transcription>]
# utt2spk     [<uterranceID> <speakerID>]

# TO-DO: use bash script to prepare those three files instead to 
# make the whole process smoother. For some reason, python would
# insert extra newline at the end of the file.
echo "Preparing speeach data for training!"
./prep_data.sh sub_train.txt data/audio label_train.txt data/train
# Making spk2utt files
utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
echo "Preparing speeach data for testing!"
./prep_data.sh sub_test.txt data/audio label_test.txt data/test
# Making spk2utt files
utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt


echo
echo "===== PREPARING LANGUAGE DATA ====="
echo
# Needs to be prepared by hand (or using self written scripts):
#
# lexicon.txt           [<word> <phone 1> <phone 2> ...]
# nonsilence_phones.txt [<phone>]
# silence_phones.txt    [<phone>]
# optional_silence.txt  [<phone>]
# corpus.txt            [<text_transcription>]
utils/prepare_lang.sh data/local/dict "<UNK>" data/local/lang data/lang

echo
echo "===== FEATURES EXTRACTION ====="
echo
# Making feats.scp files
mfccdir=mfcc
# Uncomment and modify arguments in scripts below if you have any problems with data sorting
utils/validate_data_dir.sh data/train 
utils/validate_data_dir.sh data/test
utils/fix_data_dir.sh data/train
utils/fix_data_dir.sh data/test

# Include options for allowing downsampling the audio
steps/make_mfcc.sh --nj $nj --cmd "$train_cmd" --mfcc-config conf/mfcc.conf data/train exp/make_mfcc/train $mfccdir
steps/make_mfcc.sh --nj $nj --cmd "$train_cmd" --mfcc-config conf/mfcc.conf data/test exp/make_mfcc/test $mfccdir
# Making cmvn.scp files
steps/compute_cmvn_stats.sh data/train exp/make_mfcc/train $mfccdir
steps/compute_cmvn_stats.sh data/test exp/make_mfcc/test $mfccdir

# Validate the training data directory
#utils/validate_data_dir.sh data/train
#utils/validate_data_dir.sh data/test