#!/usr/bin/env python2


# scrape.py
# Megan Swanson
# SUPERB 
# 29.6.2017
#
#
#
#
#
#
#

import requests, csv, sys, datetime
import numpy as np

# Checks to see if                                              
def is_number(s):
	try:
		int(s)
		return True
	except ValueError:
		return False


# Process one day and return averages for each type of generation
def processDay (year, month, day):
	# 20170619
	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month
	currDay = now.day

	if currDay == 1:  # Date wraps around to last day of last month
		if currMonth == 3:  # Month before was February with 28 days
			yesterday = 28
		elif currMonth == (5 or 7 or 10 or 12):  # Month before had 30 days
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

	if page.status_code == requests.codes.ok:
		#print date
		f = open('data.txt', 'r+')
		f.write(str(page.content))
		#print f.read()
		f.close()
		#print data.txt

		Renewables = np.zeros((24, 7))
		All = np.zeros((24, 5))
		avgRenew = np.zeros((24, 7))
		avgAll = np.zeros((24, 5))
		#Renewables = [[None for x in range(wR)] for y in range(hR)]
		#All = [[None for x in range(wA)] for y in range(hA)] 

		rowCount = 0
		lineCount = 0

		geothermal = int(0)
		biomass = int(0)
		biogas = int(0)
		smallHydro = int(0)
		windTotal = int(0)
		solarPV = int(0)
		solarThermal = int(0)

		renewablesTotal = int(0)
		nuclear = int(0)
		thermal = int(0)
		imports = int(0)
		hydro = int(0)

		if (year == 2012 and month < 12) or (year < 2012):
			rColumnsLimit = 14
		else:
			rColumnsLimit = 16


		with open("data.txt") as input:
			for line in csv.reader(input, delimiter="\t"):
				columnCount = 0;
				isEmpty = 0
				if lineCount > 1 and lineCount < 26:
					for x in range(0,rColumnsLimit):
						if (line[x] != '' and line[x] != None):
							#print "-------"
							#print rowCount, columnCount, line[x], int(line[x])
							if is_number(line[x]):
								#print int(line[x])
								Renewables[rowCount][columnCount] = int(line[x])
								#print int(Renewables[rowCount][columnCount])
								columnCount += 1
								isEmpty = 1
								
								#print "-------"
							else:
								isEmpty = 0
								#print "-------"
								#print rowCount, x, "no data"
								#print "-------"

					if isEmpty == 1:
						rowCount += 1
				if lineCount > 29 and lineCount < (30+24):
					for x in range(0,14):
						if line[x] != '':
							#print "-------"
							#print rowCount - 24, columnCount, line[x]
							if is_number(line[x]):
								All[rowCount-24][columnCount] = int(line[x])
								columnCount += 1
								isEmpty = 1
							else: 
								isEmpty = 0
							#print All[rowCount-24][columnCount]
							#print "-------"
						#else:
							#print "-------"
							#print rowCount, x, "no data"
							#print "-------"
					if isEmpty == 1:
						rowCount += 1
				lineCount += 1
	
		# for i in range(0, 24):
		# 	geothermal += Renewables[i][1]
		# 	biomass += Renewables[i][2]
		# 	biogas += Renewables[i][3]
		# 	smallHydro += Renewables[i][4]
		# 	windTotal += Renewables[i][5]
		# 	solarPV += Renewables[i][6]
		# 	solarThermal += Renewables[i][7]

		# 	renewablesTotal += All[i][1]
		# 	nuclear += All[i][2]
		# 	thermal += All[i][3]
		# 	imports += All[i][4]
		# 	hydro += All[i][5]

		# hours = int(24)

		# avgRenew[0] = geothermal/hours
		# avgRenew[1] = biomass/hours
		# avgRenew[2] = biogas/hours
		# avgRenew[3] = smallHydro/hours
		# avgRenew[4] = windTotal/hours
		# avgRenew[5] = solarPV/hours
		# avgRenew[6] = solarThermal/hours

		# avgAll[0] = renewablesTotal/hours
		# avgAll[1] = nuclear/hours
		# avgAll[2] = thermal/hours
		# avgAll[3] = imports/hours
		# avgAll[4] = hydro/hours
		
		# print "----------"
		# print avgRenew[0]
		# print "----------"
		# print avgAll
		# print "----------"

		# return avgRenew, avgAll
		return Renewables, All
	else:
		# print ; print "NO DATA FOR: " + str(date); print ;
		return np.empty(7), np.empty(5)


def processMonth( year, month ):
	totalRenew = np.zeros((24,7))
	totalAll = np.zeros((24,5))

	avgRenew = np.zeros((24,7))
	avgAll = np.zeros((24,5))

	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month
	currDay = now.day

	#print month

	if year == 2010:
		if month == 4: # Finish April
			days = int(10)
			for d in range(20, 31):
				Renew, All = processDay(year, month, d)
				if (Renew.all() != None and All.all() != None):
					for i in range(0, 24):
						for j in range(0, 7):
							totalRenew[i][j] += Renew[i][j]
						for k in range(0, 5):
							totalAll[i][k] += All[i][k]

	elif year == currYear:
		if month == currMonth:  # Only go up to current day
			days = int(currDay)
			for d in range(1, currDay):
				Renew, All = processDay(year, month, d)
				if (Renew.all() != None and All.all() != None):
					for i in range(0, 24):
						for j in range(0, 7):
							totalRenew[i][j] += Renew[i][j]
						for k in range(0, 5):
							totalAll[i][k] += All[i][k]
			
	if month == 2:  # february has 28 days
		days = int(28)
		for d in range(1, 29):
			Renew, All = processDay(year, month, d)
			if (Renew.all() != None and All.all() != None):
				for i in range(0, 24):
					for j in range(0, 7):
						totalRenew[i][j] += Renew[i][j]
					for k in range(0, 5):
						totalAll[i][k] += All[i][k]

	elif month == 4 or month == 6 or month == 9 or month == 11: # Months with 30 days
		days = int(30)
		for d in range(1, 31):
			Renew, All = processDay(year, month, d)
			if (Renew.all() != None and All.all() != None):
				for i in range(0, 24):
					for j in range(0, 7):
						totalRenew[i][j] += Renew[i][j]
					for k in range(0, 5):
						totalAll[i][k] += All[i][k]
	else:  # Months with 31 days
		days = int(31)
		for d in range(1, 32):
			Renew, All = processDay(year, month, d)
			if (Renew.all() != None and All.all() != None):
				for i in range(0, 24):
					for j in range(0, 7):
						totalRenew[i][j] += Renew[i][j]
					for k in range(0, 5):
						totalAll[i][k] += All[i][k]
	for l in range(0, 24):
		for m in range(0, 7):
			avgRenew[l][m] = totalRenew[l][m]/days
		for n in range(0, 5):
			avgAll[l][n] = totalAll[l][n]/days

	# print "----------"
	# print days
	# # print "----------"
	# # print "totalRenew: "
	# # print totalRenew
	# # print "avgRenew: " 
	# # print avgRenew
	# print "----------"
	# print "totalAll: " 
	# print totalAll
	# print "avgAll: " 
	# print avgAll
	# print "----------"

	return avgRenew, avgAll


def processYear( year ):
	totalRenew = np.zeros((24,7))
	totalAll = np.zeros((24,5))

	avgRenew = np.zeros((24,7))
	avgAll = np.zeros((24,5))

	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month

	if year == currYear:  # Only go up to current month
		months = int(currMonth)
		for m in range(1, months + 1):
			Renew, All = processMonth(year, m)
			for i in range(0, 24):
				for j in range(0, 7):
					totalRenew[i][j] += Renew[i][j]
				for k in range(0, 5):
					totalAll[i][k] += All[i][k]

	elif year == 2010:  # Starts in April
		months = int(9)
		for m in range(4, 13):  # Finish April
			Renew, All = processMonth(year, m)
			for i in range(0, 24):
				for j in range(0, 7):
					totalRenew[i][j] += Renew[i][j]
				for k in range(0, 5):
					totalAll[i][k] += All[i][k]
	
	else:  # Average whole year
		months = int(12)
		for m in range(1, 13):
			Renew, All = processMonth(year, m)
			for i in range(0, 24):
				for j in range(0, 7):
					totalRenew[i][j] += Renew[i][j]
				for k in range(0, 5):
					totalAll[i][k] += All[i][k]
	
	# Calculate averages for the year
	for l in range(0, 24):
		for x in range(0, 7):
			avgRenew[l][x] = totalRenew[l][x]/months
		for n in range(0, 5):
			avgAll[l][n] = totalAll[l][n]/months

	# print days
	# print "----------"
	# print avgRenew
	# print "----------"
	# print avgAll
	# print "----------"

	return avgRenew, avgAll	




if len(sys.argv) < 2: # No input arguments, aggregate all data since 4/20/2010
	print "No input arguments, average all possible data"
	year = None
	month = None
	day = None
elif len(sys.argv) == 2: # There is one argument for year
	year = int(sys.argv[1])	
	month = None
	day = None
	print "One input argument, average all data for year " + str(year)
elif len(sys.argv) == 3: # There are two arguments, year, month
	year = int(sys.argv[1])
	month = int(sys.argv[2])
	day = None
	print "Two input arguments, average all data for month " + str(month) + "/" + str(year)
elif len(sys.argv) == 4: # There are three arguments, year, month, day
	year = int(sys.argv[1])	
	month = int(sys.argv[2])
	day = int(sys.argv[3])
	print "Three input arguments, average all data for date " + str(day) + "/" + str(month) + "/" + str(year)

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
	print "Average all possible data"
	# Start from 04/20/2010
	for y in range(2010, currYear):
		Renew, All = processYear(y)
		for i in range(0, 24):
			for j in range(0, 7):
				totalRenew[i][j] += Renew[i][j]
			for k in range(0, 5):
				totalAll[i][k] += All[i][k]
elif month == None:  # Aggregate data for the year
	print "Average year " + str(year)
	Renew, All = processYear(year)
	for i in range(0, 24):
		for j in range(0, 7):
			totalRenew[i][j] += Renew[i][j]
		for k in range(0, 5):
			totalAll[i][k] += All[i][k]
elif day == None:  # Aggregate data for the month
	print "Average month " + str(month) + "/" + str(year)
	Renew, All = processMonth(year, month)
	for i in range(0, 24):
		for j in range(0, 7):
			totalRenew[i][j] += Renew[i][j]
		for k in range(0, 5):
			totalAll[i][k] += All[i][k]
elif year == currYear and month == currMonth and day == currDay:  
	sys.exit("Error: cannot calculate average for today")
else:  # Aggregate data for the day
	print "Average day " + str(day) + "/" + str(month) + "/" + str(year)
	Renew, All = processDay(year, month, day)
	if (Renew.all() != None and All.all() != None):
		for i in range(0, 24):
			for j in range(0, 7):
				totalRenew[i][j] += Renew[i][j]
			for k in range(0, 5):
				totalAll[i][k] += All[i][k]

print "Average Geothermal = " + str(Renew[0])
print "Average Biomass = " + str(Renew[1])
print "Average Biogas = " + str(Renew[2])
print "Average Small Hydro = " + str(Renew[3])
print "Average Wind Total = " + str(Renew[4])
print "Average Solar PV = " + str(Renew[5])
print "Average Solar Thermal = " + str(Renew[6])
print ;
print "Average Renewables = " + str(All[0])
print "Average Nuclear = " + str(All[1])
print "Average Thermal = " + str(All[2])
print "Average Imports = " + str(All[3])
print "Average Hydro = " + str(All[4])

disp(Renew);


