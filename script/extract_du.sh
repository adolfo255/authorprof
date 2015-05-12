rm $2/*

# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py -d $2 --stopwords data/stop_words/stop_words_du.txt $1

# Extrae links
python src/ef_links.py -d $2  $1

# Usando listas de polarity
python src/ef_polarity.py -d $2  $1 data/SentimentAnalysisDict/du/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2 $1 data/emoticons.txt
python src/ef_list_punctuation.py -d $2 $1 data/punctuation.txt

# Stadistica de corpus
python src/ef_statistics.py -d $2 -v $1

# POS
cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_dutch.sh $2/$FILE
python src/ef_pos.py --vect $2/pos.vec -d $2 --tag 2 $2/$FILE
rm -rf $2/$FILE


