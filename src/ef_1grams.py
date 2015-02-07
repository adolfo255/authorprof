#!/usr/bin/env python
# -*- coding: utf-8

# Importar librerías requeridas
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np
import argparse
import os
import json

# Variables de configuaración
NAME='ef_ngrams'
prefix='1grams'

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

    # Colecta todos los jsons
    dfs=[]
    idx=[]
    for root, dirs, files in os.walk(opts.DIR):
        for filename in files:
            if filename.endswith('.json'):
                with open(os.path.join(opts.DIR,filename)) as json_file:
                    info = json.load(json_file)
                    idx.extend(info['index'])
                    dfs.append(np.array(info['data']))

    # Los pega en un mismo dataframe
    df=np.concatenate(dfs)

    # Calculamos los features
    # Creamos contador
    count_vect = CountVectorizer(min_df=5)
    # Contamos
    feats = count_vect.fit_transform(np.asarray(df[:,2]))

    # Guardar df_new
    np.save(os.path.join(opts.dir,prefix),feats)

   
    with open(os.path.join(opts.dir,prefix+'.idx'),'w') as idxf:
        for idd in idx:
            print >> idxf, idd
 
   
    




