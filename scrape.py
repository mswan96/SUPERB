#!/usr/bin/env python2

import requests, csv, sys, datetime
import numpy as np

# Process one day and return averages for each type of generation
def processDay( year, month, day ):
	# 20170619
	i = datetime.datetime.now()

	currYear = i.year
	currMonth = i.month
	currDay = i.day

	if currDay == 1:  # Date wraps around to last day of last month
		if currMonth == 3:  # Month before was February with 28 days
			yesterday = 28
		else if currMonth == (5 or 7 or 10 or 12):  # Month before had 30 days
			yesterday = 30
		else:  # Month before had 31 days
			yesterday = 31
	else:
		yesterday = currDay - 1  

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

	i = datetime.datetime.now()

	currYear = i.year
	currMonth = i.month
	currDay = i.day

	if month == currMonth:  # Only go up to current day
		days = currDay
		for d in xrange(1, currDay)
			Renew, All = processDay(year, month, d)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]

	else if month == 4: # Finish April
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
	else:  # Months with 31 days
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

	i = datetime.datetime.now()

	currYear = i.year
	currMonth = i.month

	if year == currYear:  # Only go up to current month
		months = currMonth
		for m in xrange(1, currMonth + 1):
			Renew, All = processMonth(year, m)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]

	else if year == 2010:  # Starts in April
		months = 9
		for m in xrange(4, 13):  # Finish April
			Renew, All = processMonth(year, m)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	
	else:  # Average whole year
		months = 12
		for m in xrange(1, 13):
			Renew, All = processMonth(year, m)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	
	# Calculate averages for the year
	for k in xrange(0, 7):
		avgRenew[k] = totalRenew[k]/months
	for l in xrange(0, 5):
		avgAll[l] = totalAll[l]/months

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

	totalRenew = np.empty(7)
	totalAll = np.empty(5)

	avgRenew = np.empty(7)
	avgAll = np.empty(5)

	i = datetime.datetime.now()

	currYear = i.year
	currMonth = i.month
	currDay = i.day

	if year == None:  # Aggregate all data
		# Start from 04/20/2010
		months = 12
		for y in xrange(2010, currYear):
			Renew, All = processYear(y)
			for i in xrange(0, 7):
				totalRenew[i] += Renew[i]
			for j in xrange(0, 5):
				totalAll[j] += All[j]
	else if month == None:  # Aggregate data for the year
		Renew, All = processYear(year)
		for i in xrange(0, 7):
			totalRenew[i] += Renew[i]
		for j in xrange(0, 5):
			totalAll[j] += All[j]
	else if day == None:  # Aggregate data for the month
		Renew, All = processMonth(year, month)
		for i in xrange(0, 7):
			totalRenew[i] += Renew[i]
		for j in xrange(0, 5):
			totalAll[j] += All[j]
	else if year == currYear and month == currMonth and day == currDay:  
		sys.exit("Error: cannot calculate average for today")
	else:  # Aggregate data for the day
		Renew, All = processDay(year, month, day)
		for i in xrange(0, 7):
			totalRenew[i] += Renew[i]
		for j in xrange(0, 5):
			totalAll[j] += All[j]
	
	print "Average Geothermal = " + Renew[0]
	print "Average Biomass = " + Renew[1]
	print "Average Biogas = " + Renew[2]
	print "Average Small Hydro = " + Renew[3]
	print "Average Wind Total = " + Renew[4]
	print "Average Solar PV = " + Renew[5]
	print "Average Solar Thermal = " + Renew[6]
	print ;
	print "Average Renewables = " + All[0]
	print "Average Nuclear = " + All[1]
	print "Average Thermal = " + All[2]
	print "Average Imports = " + All[3]
	print "Average Hydro = " + All[4]
		



