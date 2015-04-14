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



rm $2/*
# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_it.txt $1

# Extrae links
python src/ef_links.py $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -p lb_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -p lf_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt

# Usando listas de polarity
python src/ef_polarity.py --deli '#' $1 data/SentimentAnalysisDict/it/affin-v1.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py $1 data/emoticons.txt
python src/ef_list_emoticons.py $1  data/SentimentAnalysisDict/it/taboowords_it.txt
python src/ef_list_punctuation.py $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword.py $1 data/SentimentAnalysisDict/en/SWN/SentiWN_it.csv

# Lista de Whissell
python src/ef_wissell_t.py $1/ data/SentimentAnalysisDict/it/Whissell/whissell-v1.txt

# Stadistica de corpus
python src/ef_statistics.py  $1

# POS
python src/extract_text.py $1/
bash script/tag_italian.sh $1/
python src/ef_pos.py --tag 2 $1


# gender
python src/develop.py --estimators ${est} -v $1
#python src/develop.py --estimators ${est}  -m age -w weights/en_gender.txt -v $1
python src/develop.py --estimators ${est}  -m ex -v $1
python src/develop.py --estimators ${est}  -m st -v $1
python src/develop.py --estimators ${est}  -m op -v $1
python src/develop.py --estimators ${est}  -m co -v $1
python src/develop.py --estimators ${est}  -m agre -v $1


