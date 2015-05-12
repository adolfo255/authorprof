rm $2/*
# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py -d $2 --stopwords data/stop_words/stop_words_es.txt $1

# Extrae links
python src/ef_links.py -d $2 $1

python src/ef_distance.py -d $2 $1

# ------------ Based on lists
# Usando listas de polarity
python src/ef_polarity.py -d $2 $1 data/SentimentAnalysisDict/es/polarity-AFINN.txt



# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2 $1 data/emoticons.txt
python src/ef_list_punctuation.py -d $2 $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword_es.py -d $2 $1 data/SentimentAnalysisDict/es/SWN/SentiWN_es.csv

# Lista de Whissell
python src/ef_wissell_t.py -d $2  $1/ data/SentimentAnalysisDict/es/Whissell/whissell_es.txt

# Stadistica de corpus
python src/ef_statistics.py -d $2  $1

cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_spanish.sh $2/$FILE
python src/ef_pos.py -d $2 $2/$FILE
rm -rf $2/$FILE


