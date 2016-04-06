#!/usr/bin/python
import MySQLdb
import nltk

db = MySQLdb.connect("localhost","python","password","DIT")

cursor = db.cursor()

corpus_root = nltk.data.find('corpora/childes/')
childes = CHILDESCorpusReader(corpus_root,u'.*.xml')
words = childes.words()
bgs = nltk.bigrams(words)

for n in bgs:
    word1 = str(n[0])
    word2 = str(n[1])
    cursor.execute('''INSERT INTO Bigram (word1, word2) VALUES (%s, %s)''',  (word1, word2))

# Make sure data is committed to the database
db.commit()

db.close()