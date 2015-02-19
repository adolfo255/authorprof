#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import print_function

# Importar librerías requeridas
import cPickle as pickle
import numpy as np
import scipy
import argparse
import os
import json


from sklearn.cross_validation import train_test_split

# Variables de configuaración
NAME='develop'

if __name__ == "__main__":
    # Las opciones de línea de comando
    p = argparse.ArgumentParser(NAME)
    p.add_argument("DIR",default=None,
        action="store", help="Directory with corpus with json")
    p.add_argument("-d", "--dir",
        action="store_true", dest="dir",default="feats",
        help="Default directory for features [feats]")
    p.add_argument("-v", "--verbose",
        action="store_true", dest="verbose",
        help="Verbose mode [Off]")
    opts = p.parse_args()

    # prepara función de verbose
    if opts.verbose:
        def verbose(*args):
            print(*args)
    else:   
        verbose = lambda *a: None 


    feats=['1grams']

    # Carga etiquetas 
    truth={}
    for line in open(os.path.join(opts.DIR,'truth.txt')):
        bits=line.split(':::')
        truth[bits[0]]=bits[1:]

    # Lee las etiquetas
    with open(os.path.join(opts.dir,feats[0]+'.idx'),'r') as idxf:
        ids = pickle.load(idxf)

    # Lee la matrix de features de disco
    with open(os.path.join(opts.dir,feats[0]+'.dat'), 'rb') as infile:
        x = pickle.load(infile)

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
        y_labels= [truth[id_usuario][0] for idd,id_usuario in ids]
    except ValueError:
        y_labels= [truth[id_usuario][0] for id_usuario in ids]
        
    # Pasando etiquetas a números    
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
    y=[ labels.index(label) for label in y_labels]

    # Cortando datos en training y test
    X_train, X_test, y_train, y_test = train_test_split(x.toarray(),
                                                    y, test_size=0.20)

    # Preparando la máquina de aprendizaje
    verbose("Training....")
    from sklearn.ensemble import RandomForestClassifier
    classifier=RandomForestClassifier(n_estimators=100)

    # Aprendiendo
    classifier.fit(X_train, y_train)

    # Predicioendo
    verbose("Predicting...")
    prediction = classifier.predict(X_test)
    verbose('----------\n')
    verbose("Evaluation")

    # Calculando desempeño
    from sklearn.metrics.metrics import precision_score, recall_score, confusion_matrix, classification_report, accuracy_score
    verbose( 'Accuracy              :', accuracy_score(y_test, prediction))
    verbose( 'Precision             :', precision_score(y_test, prediction))
    verbose( 'Recall                :', recall_score(y_test, prediction))
    verbose( 'Score                 :', classifier.score(X_train, y_train))
    verbose( '\nClasification report:\n', classification_report(y_test,
            prediction))
    verbose( '\nConfussion matrix   :\n',confusion_matrix(y_test, prediction))

    #plots:
    #import matplotlib.pyplot as plt
    #confusion_matrix_plot = confusion_matrix(y_test, prediction)
    #plt.title('matriz de confusion')
    #plt.colorbar()
    #plt.xlabel()
    #plt.xlabel('categoria de verdad')
    #plt.ylabel('categoria predecida')
    #plt.show()

      
        




