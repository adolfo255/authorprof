#!/bin/bash

mode="gender"
echo "Running training authorid"
while getopts m: opt; do
	case $opt in
	m)
	mode=$OPTARG
	;;
	esac
	done


rm feats/*.idx
rm feats/*.dat

#python src/ef_1grams.py --stopwords data/stop_words/stop_words_dutch.txt data/pan15/dutch
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_dutch.txt data/pan15/dutch
python src/ef_links.py data/pan15/dutch

python src/develop.py -m ${mode} -v --estimators 10000 data/pan15/dutch
