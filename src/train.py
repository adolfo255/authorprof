﻿#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import print_function

# Importar librerías requeridas
import cPickle as pickle
import scipy
import numpy as np
import argparse
import os

# Variables de configuaración
NAME='train'

if __name__ == "__main__":
    # Las opciones de línea de comando
    p = argparse.ArgumentParser(NAME)
    p.add_argument("DIR",default=None,
        action="store", help="Directory with corpus")
    p.add_argument("-m", "--mode",type=str,
        action="store", dest="mode",default="gender",
        help="Mode (gender|age|extroverted|stable|agreeable|conscientious|open) [gender]")
    p.add_argument("", "--model",type=str,
        action="store", dest="model",default="model.dat",
        help="Model name")
    p.add_argument("-f", "--folds",type=int,
        action="store", dest="folds",default=20,
        help="Folds during cross validation [20]")
    p.add_argument("-d", "--dir",
        action="store_true", dest="dir",default="feats",
        help="Default directory for features [feats]")
    p.add_argument("-v", "--verbose",
        action="store_true", dest="verbose",
        help="Verbose mode [Off]")
    p.add_argument("--estimators",
        action="store", dest="estimators",default=10000,type=int,
        help="Define el valor para n_estimators")
    opts = p.parse_args()
  

    # prepara función de verbose
    if opts.verbose:
        def verbose(*args):
            print(*args)
    else:   
        verbose = lambda *a: None 

    feats=['1grams','tfidf','lb_reyes','lb_hu','lf_reyes','lf_hu','whissell_t','links']

    if opts.mode=="gender":
        index_y=0
    elif opts.mode=="age":
        index_y=1
    elif opts.mode.startswith("ex"):
        index_y=2
    elif opts.mode.startswith("st"):
        index_y=3
    elif opts.mode.startswith("agre"):
        index_y=4
    elif opts.mode.startswith("co"):
        index_y=5
    elif opts.mode.startswith("op"):
        index_y=6

    # Carga etiquetas 
    truth={}
    for line in open(os.path.join(opts.DIR,'truth.txt')):
        bits=line.split(':::')
        truth[bits[0]]=bits[1:]


    # Carga las matrices
    x=[]
    feats_=[]
    for feat in feats:
        verbose('Loading:', feat)
        # Lee los indices de los rengloes
        try:
            with open(os.path.join(opts.dir,feat+'.idx'),'rb') as idxf:
                ids = pickle.load(idxf)
        except IOError:
            verbose('Warning, no features...')
            continue

        # Lee la matrix de features de disco
        with open(os.path.join(opts.dir,feat+'.dat'), 'rb') as infile:
            x_ = pickle.load(infile)
            if type(x_) is scipy.sparse.csr.csr_matrix:
                x_ = x_.toarray()
        x.append(x_)
        feats_.append(feat)

    verbose("Loaded",len(x),"matrix features")
    for feat,x_ in zip(feats_,x):
        verbose('Sumary', feat)
        verbose("Rows     :", x_.shape[0] )
        verbose("Features :", x_.shape[1] )
        verbose('----------\n')


    x=np.hstack(x)

    # Checa que etiquetas e identificatores coincidan
    if not x.shape[0]==len(ids):
        print("Error con matrix de features {0} e identificadores {1}".
            format(len(x.shape), x.shape[0]))


    verbose("Truth    :", len(truth) )
    verbose("Ids      :", len(ids) )
    verbose("Rows     :", x.shape[0] )
    verbose("Features :", x.shape[1] )
    verbose('----------\n')

    # recuperando las etiquetas
    try:
        y_labels= [truth[id_usuario][index_y] for idd,id_usuario in ids]
    except ValueError:
        y_labels= [truth[id_usuario][index_y] for id_usuario in ids]
        
    # Pasando etiquetas a números    
    if opts.mode in ['age','gender']:
        labels={}
        for label in y_labels:
            try:
                labels[label]+=1
            except KeyError:
                labels[label]=1

        labels=labels.keys()
        for label in labels:
            verbose("Label",label,"-->",labels.index(label))
        verbose('----------\n')

        # Creando el vector de etiquetas
        y=np.array([ labels.index(label) for label in y_labels])
    else:
        y=np.array([float(l) for l in y_labels])
        print(y)


    y_=[]
    prediction_=[]
    verbose("Training")
    X_train, y_train = x,y

    if opts.mode in ['age','gender']:
        # Preparando la máquina de aprendizaje
        from sklearn.ensemble import RandomForestClassifier
        classifier=RandomForestClassifier(n_estimators=opts.estimators)

        # Aprendiendo
        classifier.fit(X_train, y_train)
        model = classifier
    else:
         # Preparando la máquina de aprendizaje
        from sklearn.ensemble import RandomForestRegressor
        regressor=RandomForestRegressor(n_estimators=opts.estimators)
        model = regressor

    stream_model = pickle.dumps(model)
    verbose("Saving model into ",opts.model)
    with open(opts.model,"w") as modelf:
        modelf.write(stream_model)


