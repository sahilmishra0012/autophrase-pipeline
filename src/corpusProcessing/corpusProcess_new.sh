#!/bin/bash
DATA=$1
path=$(pwd)
echo $path
LANGUAGE=EN
MIN_SUP=10
THREAD=$2

green=`tput setaf 2`
reset=`tput sgr0`
echo ${green}==='Corpus Name:' $DATA===${reset}
echo ${green}==='Current Path:' $path===${reset}


### Following clean the raw input data from corpus.txt -> corpus.clean.txt
echo ${green}===Cleaning input corpus===${reset}
python3 cleanCorpus.py $DATA

### Following are the parameters used in auto_phrase.sh
RAW_TRAIN=${RAW_TRAIN:- ../../../data/$DATA/source/corpus.clean.txt}
QUALITY_WIKI_ENTITIES=data/EN/wiki_quality.txt

### Following are the parameters used in phrasal_segmentation.sh
HIGHLIGHT_MULTI=${HIGHLIGHT_MULTI:- 0.5}
HIGHLIGHT_SINGLE=${HIGHLIGHT_SINGLE:- 0.9}


echo ${green}===Running AutoPhrase===${reset}
cd ../tools/AutoPhrase
make
echo ${green}==='RAW_TRAIN:' $RAW_TRAIN===${reset}
echo "auto_phrase.sh parameters:" $DATA $RAW_TRAIN $MIN_SUP $QUALITY_WIKI_ENTITIES $THREAD
chmod +x ./auto_phrase.sh
./auto_phrase.sh $DATA $RAW_TRAIN $MIN_SUP $QUALITY_WIKI_ENTITIES $THREAD
echo "phrasal_segmentation.sh parameters:" $DATA $RAW_TRAIN $HIGHLIGHT_MULTI $HIGHLIGHT_SINGLE $THREAD
chmod +x ./phrasal_segmentation.sh
./phrasal_segmentation.sh $DATA $RAW_TRAIN $HIGHLIGHT_MULTI $HIGHLIGHT_SINGLE $THREAD

if [ ! -d ../../../data/$DATA/intermediate ]; then
    mkdir ../../../data/$DATA/intermediate
fi

mv models/$DATA/segmentation.txt ../../../data/$DATA/intermediate/segmentation.txt
mv models/$DATA/AutoPhrase_multi-words.txt ../../../data/$DATA/intermediate/AutoPhrase_multi-words.txt
mv models/$DATA/AutoPhrase_single-word.txt ../../../data/$DATA/intermediate/AutoPhrase_single-word.txt
mv models/$DATA/AutoPhrase.txt ../../../data/$DATA/intermediate/AutoPhrase.txt