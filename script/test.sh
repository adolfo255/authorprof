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
if [[ $LANG ==  *"lang=\"es\""* ]]
then
	# Compreses model
	pushd ${modeldir}
	tar -xzvf model_es.tgz .
	popd
	bash script/test_all_es.sh ${testdir} ${modeldir} ${outdir}
fi
if [[ $LANG ==  *"lang=\"it\""*  ]]
then
	# Compreses model
	pushd ${modeldir}
	tar -xzvf model_it.tgz .
	popd
	bash script/test_all_it.sh ${testdir} ${modeldir} ${outdir}
fi
if [[ $LANG ==  *"lang=\"nl\""*  ]]
then
	pushd ${modeldir}
	tar -xzvf model_du.tgz .
	popd
	bash script/test_all_du.sh ${testdir} ${modeldir} ${outdir}

fi


