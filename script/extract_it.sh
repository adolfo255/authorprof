rm $2/*

# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py -d $2 --stopwords data/stop_words/stop_words_it.txt $1

# Extrae links
python src/ef_links.py -d $2 $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -d $2 -p lb_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -d $2 -p lf_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt

# Usando listas de polarity
python src/ef_polarity.py -d $2 --deli '#' $1 data/SentimentAnalysisDict/it/afinn-v1.txt


python src/ef_distance.py -d $2 $1

# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2 $1 data/emoticons.txt
python src/ef_list_emoticons.py -d $2 $1  data/SentimentAnalysisDict/it/taboowords_it.txt
python src/ef_list_punctuation.py -d $2 $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword_it.py -d $2 $1 data/SentimentAnalysisDict/it/SWN/SentiWN_it.tsv

# Lista de Whissell
python src/ef_wissell_t.py -d $2 $1/ data/SentimentAnalysisDict/it/Whissell/whissell-v1.txt

# Stadistica de corpus
python src/ef_statistics.py  -d $2 $1

# POS
cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_italian.sh $2/$FILE
python src/ef_pos.py -d $2 --tag 2 $2/$FILE
rm -rf $2/$FILE


