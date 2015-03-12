# -*- coding: utf-8 -*-
#aqui ya jala
import re
file__1 = '/Users/user/Desktop/usuarios.txt'

#Pos
file__2 = '/Users/user/Downloads/SentimentAnalysisDict/en/Reyes/counterFactuality-english.txt'
#Neg
#falta especificar que lista de palabras se le pasará
file__3= ''

tweets = [[line.strip()] for line in open(file__1)]

#numero de usuarios:
#print len(lines)

#regresamos todas las opiniones de los usuarios en una lista de listas
#print tweets
print len(tweets)


list_of_words = [line.strip() for line in open(file__2)]
print list_of_words

#Este_seria:
#list_of_words_2 = [line.strip() for line in open(file_3)]

#aqui_paso_el_mismo_archivo_porque_no_sabia_cual_pero_sirve_para_otro
list_of_words_2 = [line.strip() for line in open(file__2)]
print list_of_words_2

counts = []
#j son los usuarios
for i,j in enumerate(tweets):
        #print 'esto es j',j
        countador = 0
        countador_2 = 0
        for x in list_of_words:
            if re.search(r'(?i)\b'+x+r'\b', j[0]):
                countador += 1


        for y in list_of_words_2:
            if re.search(r'(?i)\b'+y+r'\b', j[0]):
                countador_2 += 1
                #print "aqui\n",countador_2
                
        counts.append((countador,countador_2))

print "\nCounts:\n",counts
#vemos que son 152 perfiles
#print len(counts)



