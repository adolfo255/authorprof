#!/bin/bash

rm feats/*.idx
rm feats/*.dat

python src/ef_1grams.py data/pan15/english
python src/ef_tfidf.py data/pan15/english
python src/ef_list_baseline.py -p lb_reyes data/pan15/english data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt
python src/ef_list_frequency.py -p lf_reyes data/pan15/english data/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt data/SentimentAnalysisDict/en/Reyes/temporalCompression-english.txt


python src/ef_list_baseline.py -p lb_hu data/pan15/english data/SentimentAnalysisDict/en/Hu-Liu/positives.txt data/SentimentAnalysisDict/en/Hu-Liu/negatives.txt
python src/ef_list_frequency.py -p lf_hu data/pan15/english data/SentimentAnalysisDict/en/Hu-Liu/positives.txt data/SentimentAnalysisDict/en/Hu-Liu/negatives.txt


python src/develop.py -v data/pan15/english
