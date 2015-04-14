#!/bin/bash

mode="gender"
est=10
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
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_it.txt $1

# Extrae links
#python src/ef_links.py $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -p lb_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -p lf_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt

# Usando listas de polarity
python src/ef_polarity.py --deli \# $1 data/SentimentAnalysisDict/it/afinn-v1.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py $1 data/emoticons.txt
python src/ef_list_emoticons.py $1  data/SentimentAnalysisDict/it/taboowords_it.txt
python src/ef_list_punctuation.py $1 data/punctuation.txt

# Sentiword
#python src/ef_sentiword_2.py $1 data/SentimentAnalysisDict/it/SWN/SentiWN_it.csv
#
# Lista de Whissell
python src/ef_wissell_t.py $1/ data/SentimentAnalysisDict/it/Whissell/whissell-v1.txt

# Stadistica de corpus
python src/ef_statistics.py  $1

# POS
python src/extract_text.py $1/
bash script/tag_italian.sh $1/
python src/ef_pos.py --tag 2 $1


# gender
python src/test.py --model model_ge.model -d $2 --estimators ${est} $1 > $3/res_gender.txt
#python src/test.py --model model_age.model -d $2 --estimators ${est}  -m age  -v $1 > $3/res_age.txt
python src/test.py --model model_ex.model -d $2 --estimators ${est}  -m ex $1> $3/res_ex.txt
python src/test.py --model model_st.model -d $2 --estimators ${est}  -m st $1> $3/res_st.txt
python src/test.py --model model_op.model -d $2 --estimators ${est}  -m op $1> $3/res_op.txt
python src/test.py --model model_co.model -d $2 --estimators ${est}  -m co $1> $3/res_co.txt
python src/test.py --model model_agr.model -d $2 --estimators ${est}  -m agre $1> $3/res_agr.txt

python src/mix_results.py --lang it -l gender $3/res_gender.txt -l ex $3/res_ex.txt -l st $3/res_st.txt -l op $3/res_op.txt -l co $3/res_co.txt -l agre $3/res_agr.txt $3
rm $3/*.txt
