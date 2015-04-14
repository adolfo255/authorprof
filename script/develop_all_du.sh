#!/bin/bash

mode="gender"
est=2000
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



rm feats/*
# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_du.txt data/pan15/dutch

# Extrae links
python src/ef_links.py data/pan15/dutch

# Usando listas de polarity
python src/ef_polarity.py data/pan15/dutch data/SentimentAnalysisDict/du/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py data/pan15/dutch data/emoticons.txt
python src/ef_list_punctuation.py data/pan15/dutch data/punctuation.txt

# Stadistica de corpus
python src/ef_statistics.py -v data/pan15/dutch

# POS
cp -r data/pan15/dutch $2
python src/extract_text.py $2/data/pan15/dutch/
bash script/tag_dutch.sh $2/data/pan15/dutch/
python src/ef_pos.py --tag 2 $2/data/pan15/dutch


# gender
python src/develop.py --estimators ${est} -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m ex -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m st -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m op -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m co -v data/pan15/dutch
python src/develop.py --estimators ${est}  -m agre -v data/pan15/dutch


