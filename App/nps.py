#!/usr/bin/python
import MySQLdb
import nltk

db = MySQLdb.connect("localhost","python","password","DIT")

cursor = db.cursor()


from nltk.corpus.reader import CHILDESCorpusReader
words = nltk.corpus.nps_chat.words('11-08-teens_706posts.xml')
bgs = nltk.bigrams(words)
for n in bgs:
    word1 = str(n[0])
    word2 = str(n[1])
    cursor.execute('''INSERT INTO Bigram (word1, word2) VALUES (%s, %s)''',  (word1, word2))

words = nltk.corpus.nps_chat.words('10-26-teens_706posts.xml')
bgs = nltk.bigrams(words)
for n in bgs:
    word1 = str(n[0])
    word2 = str(n[1])
    cursor.execute('''INSERT INTO Bigram (word1, word2) VALUES (%s, %s)''',  (word1, word2))

words = nltk.corpus.nps_chat.words('11-09-teens_706posts.xml')
bgs = nltk.bigrams(words)
for n in bgs:
    word1 = str(n[0])
    word2 = str(n[1])
    cursor.execute('''INSERT INTO Bigram (word1, word2) VALUES (%s, %s)''',  (word1, word2))

# Make sure data is committed to the database
db.commit()

db.close()