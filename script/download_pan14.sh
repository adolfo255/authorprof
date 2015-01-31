#!/bin/bash


if [ ! -f pan14-author-profiling-training-corpus-spanish-twitter-2014-04-16.zip ]; then
	echo "Original spanish zip file not found"
	read -p "Do you want to download spanish pan14 corpus? [yes/NO]" -n 1 -r
	echo   
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		wget http://turing.iimas.unam.mx/~ivanvladimir/pan14-author-profiling-training-corpus-spanish-twitter-2014-04-16.zip 
	fi
fi

if [ ! -f pan14-author-profiling-training-corpus-english-twitter-2014-04-16.zip ]; then
	echo "Original english zip file not found, please download it"
	read -p "Do you want to download english pan14 corpus? [yes/NO]" -n 1 -r
	echo   
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		wget http://turing.iimas.unam.mx/~ivanvladimir/pan14-author-profiling-training-corpus-english-twitter-2014-04-16.zip 
	fi
fi


unzip pan14-author-profiling-training-corpus-spanish-twitter-2014-04-16.zip 
unzip pan14-author-profiling-training-corpus-english-twitter-2014-04-16.zip 

mv mnt/nfs/tira/data/pan14-training-corpora-truth/pan14-author-profiling-training-corpus-english-twitter-2014-04-16 data/pan14_english
mv mnt/nfs/tira/data/pan14-training-corpora-truth/pan14-author-profiling-training-corpus-spanish-twitter-2014-04-16 data/pan14_spanish

rmdir -p mnt/nfs/tira/data/pan14-training-corpora-truth

