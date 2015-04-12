#!/usr/bin/env python
# -*- coding: utf-8
from __future__ import print_function

# Importar librerías requeridas
import cPickle as pickle
import scipy
import numpy as np
import argparse
import os
from config import feats
from itertools import izip

# Variables de configuaración
NAME='train'

if __name__ == "__main__":
    # Las opciones de línea de comando
    p = argparse.ArgumentParser(NAME)
    p.add_argument("DIR",default=None,
        action="store", help="Directory with corpus")
    p.add_argument("-l",type=str,nargs=2,
        action="append", dest="options",default=[],
        help="Mode (gender|age|extroverted|stable|agreeable|conscientious|open) [gender]")
    p.add_argument("--lang",type=str,
        action="store", dest="lang",default="en",
        help="Mode (gender|age|extroverted|stable|agreeable|conscientious|open) [gender]")
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

    labels={}
    for label,filename in izip(opts.options,opts.options):
        labeling={}
        for line in open(filename):
            line=line.strip().split()
            labeling[line[0]]=line[1]
        labels[label]=labeling
        
    xml_='<author id="{user}"\ntype="twitter"\nlang="{lang}"'

    for user in labels['gender'].keys():
        xml=xml_.format(user=user,lang=opts.lang)
        for label,labeling in labels.iteritems():
            if label=="gender":
                if labeling['user']=='0':
                    xml+='gender="male"\n'
                else:
                    xml+='gender="female"\n'
            elif label=="age":
                if labeling[user]=='0':
                    xml+='age_group="18-24"\n'
                elif labeling[user]=='1':
                    xml+='age_group="15-34"\n'
                elif labeling[user]=='2':
                    xml+='age_group="35-49"\n'
                else:
                    xml+='age_group="50-xx"\n'
            elif label.startswith("ex"):
                xml+='extroverted="{0}"\n'.format(labeling[user])
            elif label.startswith("st"):
                xml+='stable="{0}"\n'.format(labeling[user])
            elif label.startswith("agre"):
                xml+='agreeable="{0}"\n'.format(labeling[user])
            elif label.startswith("co"):
                xml+='conscientious="{0}"\n'.format(labeling[user])
            elif label.startswith("op"):
                xml+='open="{0}"\n'.format(labeling[user])
        xml=xml+'\n/>'

