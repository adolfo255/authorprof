#!/bin/bash

rm feats/*

python src/ef_1grams.py data/pan15/dutch
python src/ef_tfidf.py data/pan15/dutch

python src/develop.py -v data/pan15/dutch
