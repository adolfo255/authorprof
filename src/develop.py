#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import print_function

# Importar librerías requeridas
import cPickle as pickle
import numpy as np
import argparse
import os


from sklearn.cross_validation import KFold
from sklearn.metrics.metrics import precision_score, recall_score, confusion_matrix, classification_report, accuracy_score, f1_score


# Variables de configuaración
NAME='develop'

if __name__ == "__main__":
    # Las opciones de línea de comando
    p = argparse.ArgumentParser(NAME)
    p.add_argument("DIR",default=None,
        action="store", help="Directory with corpus")
    p.add_argument("-m", "--mode",type=str,
        action="store", dest="mode",default="gender",
        help="Mode (gender|age) [gender]")
    p.add_argument("-f", "--folds",type=int,
        action="store", dest="folds",default=10,
        help="Folds during cross validation [10]")
    p.add_argument("-d", "--dir",
        action="store_true", dest="dir",default="feats",
        help="Default directory for features [feats]")
    p.add_argument("-v", "--verbose",
        action="store_true", dest="verbose",
        help="Verbose mode [Off]")
    p.add_argument("--estimators",
        action="store", dest="estimators",default=100,type=int,
        help="Define el valor para n_estimators")
    opts = p.parse_args()
  

    

    # prepara función de verbose
    if opts.verbose:
        def verbose(*args):
            print(*args)
    else:   
        verbose = lambda *a: None 

    feats=['tfidf']

    if opts.mode=="gender":
        index_y=0
    elif opts.mode=="age":
        index_y=1


    # Carga etiquetas 
    truth={}
    for line in open(os.path.join(opts.DIR,'truth.txt')):
        bits=line.split(':::')
        truth[bits[0]]=bits[1:]

    # Lee las etiquetas

    with open(os.path.join(opts.dir,feats[0]+'.idx'),'rb') as idxf:
        ids = pickle.load(idxf)

    # Lee la matrix de features de disco
    with open(os.path.join(opts.dir,feats[0]+'.dat'), 'rb') as infile:
        x = pickle.load(infile)
        x = x.toarray()

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

    kf = KFold(len(y), n_folds=opts.folds)
    y_=[]
    prediction_=[]
    verbose("Cross validation:")
    for i,(train,test) in enumerate(kf):
        # Cortando datos en training y test
        X_train, X_test, y_train, y_test = x[train],x[test],y[train],y[test]

        # Preparando la máquina de aprendizaje
        verbose("   Training fold   (%i)"%(i+1))
        from sklearn.ensemble import RandomForestClassifier
        classifier=RandomForestClassifier(n_estimators=opts.estimators)

        # Aprendiendo
        classifier.fit(X_train, y_train)

        # Prediciendo
        verbose("   Predicting fold (%i)"%(i+1))
        prediction = classifier.predict(X_test)
    
        verbose('   Accuracy fold   (%i):'%(i+1), accuracy_score(y_test, prediction))
        y_.extend(y_test)
        prediction_.extend(prediction)


    verbose('----------\n')
    verbose("Evaluation")

    # Calculando desempeño
    print( 'Accuracy              :', accuracy_score(y_, prediction_))
    print( 'Precision             :', precision_score(y_, prediction_))
    print( 'Recall                :', recall_score(y_, prediction_))
    print( 'F-score               :', f1_score(y_, prediction_))
    print( '\nClasification report:\n', classification_report(y_,
            prediction_))
    print( '\nConfussion matrix   :\n',confusion_matrix(y_, prediction_))

    #plots:
    #import matplotlib.pyplot as plt
    #confusion_matrix_plot = confusion_matrix(y_test, prediction)
    #plt.title('matriz de confusion')
    #plt.colorbar()
    #plt.xlabel()
    #plt.xlabel('categoria de verdad')
    #plt.ylabel('categoria predecida')
    #plt.show()

      
        




