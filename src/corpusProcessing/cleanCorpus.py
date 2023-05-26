import sys
import re

corpusName = sys.argv[1]
inputFileName = '../../data/'+corpusName+'/source/corpus.txt'
outputFileName = '../../data/'+corpusName+'/source/corpus.clean.txt'

with open(inputFileName) as fin, open(outputFileName, 'w') as f_corpus:
    for doc in fin:
        doc = doc.strip()
        doc = re.sub(r"[^\x00-\x7F]+", "", doc)
        doc = " ".join(doc.split("\t"))
        doc = re.sub(r"\s{2,}", " ", doc)
        doc = doc.lower()
        f_corpus.write(doc+'\n')

fin.close()
f_corpus.close()