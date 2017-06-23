#!/usr/bin/env python2

import requests, csv, sys, datetime
import numpy as np

# Process one day and return averages for each type of generation
def processDay( year, month, day ):
	# 20170619
	if month < 10:
		monthstr = "0" + str(month)
	else:
		monthstr = str(month)
	if day < 10:
		daystr = "0" + str(day)
	else: 
		daystr = str(day)

	date = str(year) + monthstr + daystr

	url = "http://content.caiso.com/green/renewrpt/" + str(date) + "_DailyRenewablesWatch.txt"

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
						print "-------"
						print rowCount, columnCount, line[x]
						Renewables[rowCount][columnCount] = int(line[x])
						print Renewables[rowCount][columnCount]
						print "-------"
						columnCount += 1
						isEmpty = 1
					else:
						print "-------"
						print rowCount, x, "no data"
						print "-------"
				if isEmpty == 1:
					rowCount += 1
			if lineCount > 29 and lineCount < (28+26):
				for x in xrange(0,18):
					if line[x] != '':
						print "-------"
						print rowCount - 25, columnCount, line[x]
						All[rowCount-24][columnCount] = int(line[x])
						print All[rowCount-25][columnCount]
						print "-------"
						columnCount += 1
						isEmpty = 1
					else:
						print "-------"
						print rowCount, x, "no data"
						print "-------"
				if isEmpty == 1:
					rowCount += 1
			lineCount += 1
	
	for i in xrange(0, 24):
		geothermal += Renewables[i][1]
		biomass += Renewables[i][2]
		biogas += Renewables[i][3]
		smallHydro += Renewables[i][4]
		windTotal += Renewables[i][5]
		solarPV += Renewables[i][6]
		solarThermal += Renewables[i][7]

		renewablesTotal += All[i][1]
		nuclear += [i][2]
		thermal += [i][3]
		imports += [i][4]
		hydro += [i][5]

	#avgRenewables = np.empty([2, 7])

	avgRenewables[0] = geothermal/24
	avgRenewables[1] = biomass/24
	avgRenewables[2] = biogas/24
	avgRenewables[3] = smallHydro/24
	avgRenewables[4] = windTotal/24
	avgRenewables[5] = solarPV/24
	avgRenewables[6] = solarThermal/24

	avgAll[0] = renewablesTotal/24
	avgAll[1] = nuclear/24
	avgAll[2] = thermal/24
	avgAll[3] = imports/24
	avgAll[4] = hydro/24
	# average[1][5] = None
	# average[1][6] = None

return avgRenewables, avgAll


def processMonth( year, month ):
	totalRenew = np.empty(7)
	totalAll = np.empty(5)

	avgRenew = np.empty(7)
	avgAll = np.empty(5)

	if month == 4: # Finish April
		days = 10
		for d in xrange(20, 31):
			Renew, All = processDay(year, month, d)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
			
	else if month == 2:  # february has 28 days
		days = 28
		for d in xrange(1, 29)
			Renew, All = processDay(year, month, d)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]

	else if month == (6 or 9 or 11): # Months with 30 days
		days = 30
		for d in xrange(1, 31)
			Renew, All = processDay(year, month, d)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]	
	else if :  # Months with 31 days
		days = 31
		for d in xrange(1, 32)
			Renew, All = processDay(year, month, d)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]

	for k in xrange(0, 7):
		avgRenew[k] = totalRenew[k]/days
	for l in xrange(0, 5):
		avgAll[l] = totalAll[l]/days

	return avgRenew, avgAll


def processYear( year ):
	totalRenew = np.empty(7)
	totalAll = np.empty(5)

	avgRenew = np.empty(7)
	avgAll = np.empty(5)

	if year == 2010: 
		months = 9
		for m in xrange(4, 13): # Finish April
			Renew, All = processMonth(year, m)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	else:
		months = 12
		for m in xrange(1, 13): # Finish April
			Renew, All = processMonth(year, m)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	
	for k in xrange(0, 7):
		avgRenew[k] = totalRenew[k]/days
	for l in xrange(0, 5):
		avgAll[l] = totalAll[l]/days

	return avgRenew, avgAll	

def main(argv):
	if len(sys.argv) < 2: # No input arguments, aggregate all data since 4/20/2010
		year = None
		month = None
		day = None
	else if len(sys.argv) == 2: # There is one argument for year
		year = int(sys.argv[1])	
		month = None
		day = None
	else if len(sys.argv) == 3: # There are two arguments, year, month
		year = int(sys.argv[1])
		month = int(sys.argv[2])
		day = None
	else if len(sys.argv) == 4: # There are three arguments, year, month, day
		year = int(sys.argv[1])	
		month = int(sys.argv[2])
		day = int(sys.argv[3])
	else:
		sys.exit("Error: cannot input more than three arguments")

	avgDayRenew = np.empty(7)
	avgDayAll = np.empty(5)
	dayCount = 0

	i = datetime.datetime.now()

	currYear = i.year
	currMonth = i.month
	currDay = i.day

	if currDay == 1:
		if currMonth == 3:
			yesterday = 28
		else if currMonth == 5 or currMonth == 7 or currMonth == 10 or currMonth == 12:
			yesterday = 30
		else:
			yesterday = 31
	else:
		yesterday = currDay - 1  

	if year == None:  # Aggregate all data
		# Start from 04/20/2010
		months = 12
		for y in xrange(2010, 13):
			Renew, All = processYear(year)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	else:
		Renew, All = processYear(year)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]

		# for aprilDays in xrange(20, 31): # Finish April
		# 	Renew1, All1 = processDay(2010, 4, aprilDays)
		# 	dayCount += 1
		# 	for j in xrange(0, 7):
		# 		avgDayRenew[j] += Renew1[j]
		# 		avgDayAll[j] += All1[j]

		# for firstM in xrange(5, 13): # Finish 2010
		# 	if firstM == (6 or 9 or 11): # Months with 30 days
		# 		for firstD in xrange(1, 31)
		# 			Renew2, All2 = processDay(2010, firstM, firstD)
		# 			dayCount += 1
		# 			for j in xrange(0, 7):
		# 				avgDayRenew[j] += Renew2[j]
		# 				avgDayAll[j] += All2[j]
		# 	else:  # Months with 31 days (february not included in 2010)
		# 		for firstD in xrange(1, 32)
		# 			Renew2, All2 = processDay(2010, firstM, firstD)
		# 			dayCount += 1
		# 			for j in xrange(0, 7):
		# 				avgDayRenew[j] += Renew2[j]
		# 				avgDayAll[j] += All2[j]
		# # Now the rest up until yesterday
		# for y in xrange(2011, currYear):
		# 	for m in xrange(1, 13)
		# 		if m == 2:  # february has 28 days
		# 			for firstD in xrange(1, 32)
		# 			Renew2, All2 = processDay(2010, firstM, firstD)
		# 			dayCount += 1
		# 			for j in xrange(0, 7):
		# 				avgDayRenew[j] += Renew2[j]
		# 				avgDayAll[j] += All2[j]
		# 	processDay(year, month, day)
	 



