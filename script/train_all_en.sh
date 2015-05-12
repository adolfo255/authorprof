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
python src/ef_statistics.py -d $2 -v $1

cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_english.sh $2/$FILE
python src/ef_pos.py -d $2 $2/$FILE
rm -rf $2/$FILE



# gender
python src/train.py --model model_ge.model -d $2 --estimators ${est} -v $1
python src/train.py --model model_age.model -d $2 --estimators ${est}  -m age -w weights/en_gender.txt -v $1
python src/train.py --model model_ex.model -d $2 --estimators ${est}  -m ex -v $1
python src/train.py --model model_st.model -d $2 --estimators ${est}  -m st -v $1
python src/train.py --model model_op.model -d $2 --estimators ${est}  -m op -v $1
python src/train.py --model model_co.model -d $2 --estimators ${est}  -m co -v $1
python src/train.py --model model_agr.model -d $2 --estimators ${est}  -m agre -v $1


