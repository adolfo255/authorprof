#!/bin/bash

# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py -d $2 --stopwords data/stop_words/stop_words_en.txt $1

# Extrae links
python src/ef_links.py -d $2 $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -d $2 -p lb_reyes $1 data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt
python src/ef_list_frequency.py -d $2 -p lf_reyes $1 data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt

# Usando listas de polarity
python src/ef_polarity.py -d $2 $1 data/SentimentAnalysisDict/en/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2 $1 data/emoticons.txt
python src/ef_list_punctuation.py -d $2 $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword.py -d $2 $1 data/SentimentAnalysisDict/en/SWN/sentiword-net_en.tsv

# Lista de Whissell
python src/ef_wissell_t.py -d $2 $1/ data/SentimentAnalysisDict/en/Whissell/whissell_en.txt

# Stadistica de corpus
python src/ef_statistics.py -d $2  $1

cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_english.sh $2/$FILE
python src/ef_pos.py -d $2 $2/$FILE
rm -rf $2/$FILE
