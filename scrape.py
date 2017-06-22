#!/usr/bin/env python2

import requests, csv, sys
import numpy as np

#from bs4 import BeautifulSoup
if len(sys.argv) < 2:
	sys.exit("Error: must input one argument")


url = sys.argv[1]

page = requests.get(url)

f = open("data.txt", "w")
f.write(str(page.content))
f.close()

wR, hR = 8, 24
wA, hA = 6, 24

Renewables = np.empty([hR, wR])
All = np.empty([hA, wA])
#Renewables = [[None for x in range(wR)] for y in range(hR)]
#All = [[None for x in range(wA)] for y in range(hA)] 

rowCount = 0
lineCount = 0

with open("data.txt") as input:
	for line in csv.reader(input, delimiter="\t"):
		columnCount = 0;
		isEmpty = 0
		if lineCount > 1 and lineCount < 26:
			for x in xrange(0,18):
				if line[x] != '':
					#print "-------"
					#print rowCount, columnCount, line[x]
					Renewables[rowCount][columnCount] = int(line[x])
					#print Renewables[rowCount][columnCount]
					#print "-------"
					columnCount += 1
					isEmpty = 1
				#else:
					#print "-------"
					#print rowCount, x, "no data"
					#print "-------"
			if isEmpty == 1:
				rowCount += 1
		if lineCount > 29 and lineCount < (28+26):
			for x in xrange(0,18):
				if line[x] != '':
					#print "-------"
					#print rowCount - 25, columnCount, line[x]
					All[rowCount-24][columnCount] = int(line[x])
					#print All[rowCount-25][columnCount]
					#print "-------"
					columnCount += 1
					isEmpty = 1
				#else:
					#print "-------"
					#print rowCount, x, "no data"
					#print "-------"
			if isEmpty == 1:
				rowCount += 1
		lineCount += 1

#print Renewables
#print All






