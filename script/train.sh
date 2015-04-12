#!/bin/bash

testdir=

echo "Running training authorprof"
while getopts i:o:m: opt; do
	case $opt in
	i)
		testdir=$OPTARG
		;;
	o)
		outdir=$OPTARG
		;;
	esac
done

LANG=`ls ${testdir}/*.xml | head -1 | xargs grep lang`

if [[ $LANG == *"lang=\"en\""* ]]
then
	bash script/train_all_en.sh ${testdir} ${outdir}
	# Compreses model
	pushd ${outdir}
	tar -czvf /tmp/model_en.tgz .
	cp /tmp/model_en.tgz .
	popd
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


