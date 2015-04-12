#!/bin/bash

testdir=
outdir=
model='feats'

echo "Running testing authorid"
while getopts i:o:m: opt; do
	case $opt in
	i)
		testdir=$OPTARG
		;;
	m)
		modeldir=$OPTARG
		;;
	o)
		outdir=$OPTARG
		;;
	esac
done

LANG=`ls ${testdir}/*.xml | head -1 | xargs grep lang`

if [[ $LANG == *"lang=\"en\""* ]]
then
	# Compreses model
	pushd ${modeldir}
	tar -xzvf model_en.tgz .
	popd
	bash script/test_all_en.sh ${testdir} ${modeldir} ${outdir}
fi
if [[ $LANG == *"Spanish"* ]]
then
	echo hola
fi
if [[ $LANG == *"Greek"* ]]
then
	echo adios
fi
if [[ $LANG == *"Dutch"* ]]
then
	echo hhoollaa
fi


