#!/bin/bash

mode="gender"
est=2000
echo "Running testing authorprof en"
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
# ------------  Based on vocabulary
# tfidf
python src/ef_tfidf.py -d $2 --vect $2/tfidf.vec   --stopwords data/stop_words/stop_words_es.txt $1

# Extrae links
python src/ef_links.py -d $2 -l $2/links.vec  $1

# ------------ Bades on lists
# Usando listas de polarity
python src/ef_polarity.py -d $2  $1 data/SentimentAnalysisDict/es/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2  $1 data/emoticons.txt
python src/ef_list_punctuation.py -d $2  $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword_es.py -d $2  $1 data/SentimentAnalysisDict/es/SWN/SentiWN_es.csv

# Lista de Whissell
python src/ef_wissell_t.py -d $2  $1/ data/SentimentAnalysisDict/es/Whissell/whissell_es.txt

# Stadistica de corpus
python src/ef_statistics.py -d $2   $1


# POS
cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_spanish.sh  $2/$FILE
python src/ef_pos.py --vect $2/pos.vec -d $2 $2/$FILE
rm -rf $2/$FILE


# gender
python src/test.py --model model_ge.model -d $2 --estimators ${est} $1 > $3/res_gender.txt
python src/test.py --model model_age.model -d $2 --estimators ${est}  -m age $1 > $3/res_age.txt
python src/test.py --model model_ex.model -d $2 --estimators ${est}  -m ex $1> $3/res_ex.txt
python src/test.py --model model_st.model -d $2 --estimators ${est}  -m st $1> $3/res_st.txt
python src/test.py --model model_op.model -d $2 --estimators ${est}  -m op $1> $3/res_op.txt
python src/test.py --model model_co.model -d $2 --estimators ${est}  -m co $1> $3/res_co.txt
python src/test.py --model model_agr.model -d $2 --estimators ${est}  -m agre $1> $3/res_agr.txt

python src/mix_results.py --lang es -l gender $3/res_gender.txt -l age $3/res_age.txt -l ex $3/res_ex.txt -l st $3/res_st.txt -l op $3/res_op.txt -l co $3/res_co.txt -l agre $3/res_agr.txt $3
rm $3/*.txt
