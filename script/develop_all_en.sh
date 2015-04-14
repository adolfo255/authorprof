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
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_en.txt data/pan15/english

# Extrae links
python src/ef_links.py data/pan15/english

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -p lb_reyes data/pan15/english data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt
python src/ef_list_frequency.py -p lf_reyes data/pan15/english data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt

# Usando listas de polarity
python src/ef_polarity.py data/pan15/english data/SentimentAnalysisDict/en/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py data/pan15/english data/emoticons.txt
python src/ef_list_punctuation.py data/pan15/english data/punctuation.txt

# Sentiword
python src/ef_sentiword.py data/pan15/english data/SentimentAnalysisDict/en/SWN/sentiword-net_en.tsv

# Lista de Whissell
python src/ef_wissell_t.py data/pan15/english/ data/SentimentAnalysisDict/en/Whissell/whissell_en.txt

# Stadistica de corpus
python src/ef_statistics.py -v data/pan15/english

# POS
python src/extract_text.py data/pan15/english/
bash script/tag_english.sh data/pan15/english/
python src/ef_pos.py data/pan15/english


# gender
python src/develop.py --estimators ${est} -v data/pan15/english/
python src/develop.py --estimators ${est}  -m age -w weights/en_gender.txt -v data/pan15/english/
python src/develop.py --estimators ${est}  -m ex -v data/pan15/english/
python src/develop.py --estimators ${est}  -m st -v data/pan15/english/
python src/develop.py --estimators ${est}  -m op -v data/pan15/english/
python src/develop.py --estimators ${est}  -m co -v data/pan15/english/
python src/develop.py --estimators ${est}  -m agre -v data/pan15/english/
