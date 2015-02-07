#!/usr/bin/env python
# -*- coding: utf-8

# Importar librerías requeridas
import pandas as pd
import numpy as np
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

    feats=['1grams']

    # Carga etiqueta
    id2label={}
    print "Loading labels"
    for root, dirs, files in os.walk(opts.DIR):
        for filename in files:
            if filename.endswith('.json'):
                with open(os.path.join(opts.DIR,filename)) as json_file:
                    info = json.load(json_file)
                for idd,data in zip(info['index'],info['data']):
                    # Cambiar a 0 para edad
                    id2label[idd]=data[1]


    # Colecta todos los features
    dfs=[]
    idx=[]
    # Los pega en un mismo dataframe
    x=np.load(os.path.join(opts.dir,feats[0]+'.npy'))


    with open(os.path.join(opts.dir,feats[0]+'.idx'),'r') as idxf:
        for line in idxf:
            idx.append(int(line))

    print "Spliting into training and testing"
    y= [id2label[idd] for idd in idx if id2label.has_key(idd)]

    X_train, X_test, y_train, y_test = train_test_split(x,
                                                    y, test_size=0.33)

    print "Training"
    from sklearn.ensemble import RandomForestClassifier

    #se pasmo con 1000000
    #probar con mas parametros
    classifier=RandomForestClassifier(n_estimators=100)
    classifier.fit(X_train, y_train)
    print "Predicting"
    prediction = classifier.predict(X_test)

    from sklearn.metrics.metrics import precision_score, recall_score, confusion_matrix, classification_report, accuracy_score
    print '\nAccuracy:', accuracy_score(y_test, prediction)
    print '\nscore:', classifier.score(X_train, y_train)
    print '\nrecall:', recall_score(y_test, prediction)
    print '\nprecision:', precision_score(y_test, prediction)
    print '\n clasification report:\n', classification_report(y_test, prediction)
    print '\n confussion matrix:\n',confusion_matrix(y_test, prediction)

    #plots:

    import matplotlib.pyplot as plt
    confusion_matrix_plot = confusion_matrix(y_test, prediction)
    plt.title('matriz de confusion')
    plt.colorbar()
    plt.xlabel()
    plt.xlabel('categoria de verdad')
    plt.ylabel('categoria predecida')
    plt.show()

      
        




