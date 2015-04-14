#!/bin/bash

mode="gender"
est=400
echo "Running training authorprof"
while getopts m: opt; do
	case $opt in
	m)
	mode=$OPTARG
    ;;
	e)
	est=$OPTARG
	;;
	
	esac
	done



rm feats/*.idx
rm feats/*.dat

python src/ef_tfidf.py --stopwords data/stop_words/stop_words_dutch.txt data/pan15/dutch
python src/ef_links.py data/pan15/dutch
python src/ef_list_emoticons.py data/pan15/dutch data/emoticons.txt
python src/ef_list_punctuation.py data/pan15/dutch data/punctuation.txt

# gender
python src/develop.py --estimators ${est} -v data/pan15/dutch
#python src/develop.py --estimators 300  -m age  -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m ex -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m st -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m op -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m co -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m agre -v data/pan15/dutch


