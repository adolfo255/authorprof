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
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_it.txt data/pan15/italian

# Extrae links
python src/ef_links.py data/pan15/italian

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -p lb_reyes data/pan15/italian data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -p lf_reyes data/pan15/italian data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt

# Usando listas de polarity
python src/ef_polarity.py --deli '#' data/pan15/italian data/SentimentAnalysisDict/it/affin-v1.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py data/pan15/italian data/emoticons.txt
python src/ef_list_emoticons.py data/pan15/italian  data/SentimentAnalysisDict/it/taboowords_it.txt
python src/ef_list_punctuation.py data/pan15/italian data/punctuation.txt

# Sentiword
python src/ef_sentiword.py data/pan15/italian data/SentimentAnalysisDict/en/SWN/SentiWN_it.csv

# Lista de Whissell
python src/ef_wissell_t.py data/pan15/italian/ data/SentimentAnalysisDict/it/Whissell/whissell-v1.txt

# Stadistica de corpus
python src/ef_statistics.py  data/pan15/italian

# POS
python src/extract_text.py data/pan15/italian/
bash script/tag_italian.sh data/pan15/italian/
python src/ef_pos.py --tag 2 data/pan15/italian


# gender
python src/develop.py --estimators ${est} -v data/pan15/italian
#python src/develop.py --estimators ${est}  -m age -w weights/en_gender.txt -v data/pan15/italian
python src/develop.py --estimators ${est}  -m ex -v data/pan15/italian
python src/develop.py --estimators ${est}  -m st -v data/pan15/italian
python src/develop.py --estimators ${est}  -m op -v data/pan15/italian
python src/develop.py --estimators ${est}  -m co -v data/pan15/italian
python src/develop.py --estimators ${est}  -m agre -v data/pan15/italian


