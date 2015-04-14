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
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_es.txt $1

# Extrae links
python src/ef_links.py $1

# ------------ Bades on lists
# Usando listas de polarity
python src/ef_polarity.py $1 data/SentimentAnalysisDict/es/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py $1 data/emoticons.txt
python src/ef_list_punctuation.py $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword_2.py $1 data/SentimentAnalysisDict/es/SWN/SentiWN_es.csv

# Lista de Whissell
python src/ef_wissell_t.py $1/ data/SentimentAnalysisDict/es/Whissell/whissell_es.txt

# Stadistica de corpus
python src/ef_statistics.py  $1

# POS
python src/extract_text.py $1/
bash script/tag_spanish.sh $1/
python src/ef_pos.py $1

# gender
python src/test.py --model model_ge.model -d $2 --estimators ${est} -v $1 > $3/res_gender.txt
python src/test.py --model model_age.model -d $2 --estimators ${est}  -m age -v $1 > $3/res_age.txt
python src/test.py --model model_ex.model -d $2 --estimators ${est}  -m ex -v $1> $3/res_ex.txt
python src/test.py --model model_st.model -d $2 --estimators ${est}  -m st -v $1> $3/res_st.txt
python src/test.py --model model_op.model -d $2 --estimators ${est}  -m op -v $1> $3/res_op.txt
python src/test.py --model model_co.model -d $2 --estimators ${est}  -m co -v $1> $3/res_co.txt
python src/test.py --model model_agr.model -d $2 --estimators ${est}  -m agre -v $1> $3/res_agr.txt


