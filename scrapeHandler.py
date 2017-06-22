#!/usr/bin/env python2

import sys
import numpy as np

if len(sys.argv) < 2:
	sys.exit("Error: must input at least one argument")

if len(sys.argv) == 2: # There is one argument for year
	year = int(sys.argv[1])	
else if len(sys.argv) == 3: # There are two arguments, year, month
	year = int(sys.argv[1])
	month = int(sys.argv[2])
else if len(sys.argv) == 4: # There are three arguments, year, month, day
	year = int(sys.argv[1])	
	month = int(sys.argv[2])
	day = int(sys.argv[3])
else:
	sys.exit("Error: cannot input more than three arguments")


