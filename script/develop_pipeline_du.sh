#!/bin/bash

rm feats/*.idx
rm feats/*.dat

#python src/ef_1grams.py --stopwords data/stop_words/stop_words_dutch.txt data/pan15/dutch
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_dutch.txt data/pan15/dutch

python src/develop.py -v --estimators 1000 data/pan15/dutch
