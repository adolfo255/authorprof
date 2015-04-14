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
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_es.txt data/pan15/spanish/

# Extrae links
python src/ef_links.py data/pan15/spanish/

# ------------ Bades on lists
# Usando listas de polarity
python src/ef_polarity.py data/pan15/spanish/ data/SentimentAnalysisDict/es/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py data/pan15/spanish/ data/emoticons.txt
python src/ef_list_punctuation.py data/pan15/spanish/ data/punctuation.txt

# Sentiword
python src/ef_sentiword_2.py data/pan15/spanish/ data/SentimentAnalysisDict/es/SWN/SentiWN_es.csv

# Lista de Whissell
python src/ef_wissell_t.py data/pan15/spanish// data/SentimentAnalysisDict/es/Whissell/whissell_es.txt

# Stadistica de corpus
python src/ef_statistics.py  data/pan15/spanish/

# POS
python src/extract_text.py data/pan15/spanish//
bash script/tag_spanish.sh data/pan15/spanish//
python src/ef_pos.py data/pan15/spanish/


# gender
python src/develop.py --estimators ${est} -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m age -w weights/en_gender.txt -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m ex -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m st -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m op -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m co -v data/pan15/spanish/
python src/develop.py --estimators ${est}  -m agre -v data/pan15/spanish/
