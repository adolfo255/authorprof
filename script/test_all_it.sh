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
python src/ef_tfidf.py -d $2 --vect $2/tfidf.vec -stopwords data/stop_words/stop_words_it.txt $1

# Extrae links
python src/ef_links.py -l $2/links.vec  -d $2  $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -d $2  -p lb_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -d $2  -p lf_reyes $1 data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt

# Usando listas de polarity
python src/ef_polarity.py -d $2  --deli '#' $1 data/SentimentAnalysisDict/it/afinn-v1.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py -d $2  $1 data/emoticons.txt
python src/ef_list_emoticons.py -d $2  $1  data/SentimentAnalysisDict/it/taboowords_it.txt
python src/ef_list_punctuation.py -d $2  $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword_it.py -d $2  $1 data/SentimentAnalysisDict/it/SWN/SentiWN_it.tsv

# Lista de Whissell
python src/ef_wissell_t.py -d $2  $1/ data/SentimentAnalysisDict/it/Whissell/whissell-v1.txt

# Stadistica de corpus
python src/ef_statistics.py -d $2   $1

# POS
# POS
cp -r $1 $2
FILE=`basename $1`
python src/extract_text.py $2/$FILE
bash script/tag_italian.sh $2/$FILE
python src/ef_pos.py -d $2 --tag 2 $2/$FILE
rm -rf $2/$FILE


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
