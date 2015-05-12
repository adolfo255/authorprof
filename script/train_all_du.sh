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


# gender
python src/train.py --model model_ge.model -d $2 --estimators ${est} -v $1
#python src/train.py --model model_age.model -d $2 --estimators ${est}  -m age -w weights/en_gender.txt -v $1
python src/train.py --model model_ex.model -d $2 --estimators ${est}  -m ex -v $1
python src/train.py --model model_st.model -d $2 --estimators ${est}  -m st -v $1
python src/train.py --model model_op.model -d $2 --estimators ${est}  -m op -v $1
python src/train.py --model model_co.model -d $2 --estimators ${est}  -m co -v $1
python src/train.py --model model_agr.model -d $2 --estimators ${est}  -m agre -v $1


