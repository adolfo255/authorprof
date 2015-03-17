#!/bin/bash

rm feats/*.idx
rm feats/*.dat

#python src/ef_1grams.py data/pan15/italian
python src/ef_tfidf.py --stopwords data/stop_words/stop_words_it.txt data/pan15/italian
python src/ef_list_baseline.py -p lb_reyes data/pan15/italian data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt
python src/ef_list_frequency.py -p lf_reyes data/pan15/italian data/SentimentAnalysisDict/it/Reyes/counterFactuality-ita.txt data/SentimentAnalysisDict/it/Reyes/temporalCompression-ita.txt


python src/ef_list_baseline.py -p lb_hu data/pan15/italian data/SentimentAnalysisDict/it/Hu-Liu/positives.txt data/SentimentAnalysisDict/it/Hu-Liu/negatives.txt
python src/ef_list_frequency.py -p lf_hu data/pan15/italian data/SentimentAnalysisDict/it/Hu-Liu/positives.txt data/SentimentAnalysisDict/it/Hu-Liu/negatives.txt

python src/develop.py -v -m ex data/pan15/italian
