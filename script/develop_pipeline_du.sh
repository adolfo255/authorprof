#!/bin/bash

rm feats/*.idx
rm feats/*.dat

python src/ef_1grams.py data/pan15/dutch
python src/ef_tfidf.py data/pan15/dutch

python src/develop.py -v data/pan15/dutch
