#!/bin/bash

rm feats/*.idx
rm feats/*.dat

python src/ef_1grams.py --stopwords data/stop_words/stop_words_es.txt data/pan15/spanish
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_es.txt  data/pan15/spanish

python src/develop.py  -v data/pan15/spanish
