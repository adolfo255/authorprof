#!/bin/bash
DIR=xmlToJson_es/
if [ ! -d "$DIR" ]
then
mkdir $DIR
fi
DIR2=xmlToJson_en/
if [ ! -d "$DIR2" ]
then
mkdir $DIR2
fi
DIR3=tweets_es/
if [ ! -d "$DIR3" ]
then
mkdir $DIR3
fi
DIR4=tweets_en/
if [ ! -d "$DIR4" ]
then
mkdir $DIR4
fi
node xmlReader.js ../data/pan14_english xmlToJson_en
node xmlReader.js ../data/pan14_spanish xmlToJson_es
FILES=xmlToJson_en/*
for f in $FILES
do 
node readTweets.js $f
done
