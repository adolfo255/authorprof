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
python src/ef_tfidf.py --vect $2/tfidf.vec --stopwords data/stop_words/stop_words_en.txt $1

# Extrae links
python src/ef_links.py -l $2/links.vec  $1

# ------------ Bades on lists
# Usando listas de positivos y negativos
python src/ef_list_baseline.py -p lb_reyes $1 data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt
python src/ef_list_frequency.py -p lf_reyes $1 data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt

# Usando listas de polarity
python src/ef_polarity.py $1 data/SentimentAnalysisDict/en/polarity-AFINN.txt

# Emoticons y puntuación
python src/ef_list_emoticons.py $1 data/emoticons.txt
python src/ef_list_punctuation.py $1 data/punctuation.txt

# Sentiword
python src/ef_sentiword.py $1 data/SentimentAnalysisDict/en/SWN/sentiword-net_en.tsv

# Lista de Whissell
python src/ef_wissell_t.py $1/ data/SentimentAnalysisDict/en/Whissell/whissell_en.txt

# Stadistica de corpus
python src/ef_statistics.py -v $1

# POS
python src/extract_text.py $1/
bash script/tag_english.sh $1/
python src/ef_pos.py $1

# gender
python src/test.py --model model_ge.model -d $2 --estimators ${est} $1 > $3/res_gender.txt
python src/test.py --model model_age.model -d $2 --estimators ${est}  -m age $1 > $3/res_age.txt
python src/test.py --model model_ex.model -d $2 --estimators ${est}  -m ex $1> $3/res_ex.txt
python src/test.py --model model_st.model -d $2 --estimators ${est}  -m st $1> $3/res_st.txt
python src/test.py --model model_op.model -d $2 --estimators ${est}  -m op $1> $3/res_op.txt
python src/test.py --model model_co.model -d $2 --estimators ${est}  -m co $1> $3/res_co.txt
python src/test.py --model model_agr.model -d $2 --estimators ${est}  -m agre $1> $3/res_agr.txt

python src/mix_results.py -l gender $3/res_gender.txt -l age $3/res_age.txt -l ex $3/res_ex.txt -l st $3/res_st.txt -l op $3/res_op.txt -l co $3/res_co.txt -l agre $3/res_agr.txt $3
rm $3/*.txt
