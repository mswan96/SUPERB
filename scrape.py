#!/usr/bin/env python2


# scrape.py
# Megan Swanson
# SUPERB 
# 14.8.2017
#
#	Averages hourly energy generation data from CAISO based on type of generation.
#	http://www.caiso.com/market/Pages/ReportsBulletins/DailyRenewablesWatch.aspx
#	Four different modes: 
#		No input: Averages all available data from start(04/20/2010) to the day
#			  before the current date.
#		One input: Averages all available data for the input year (2010-2017)
#		Two inputs: Averages all available data for the input month (1-12 2010-2017)
#		Three inputs: Averages all available data for the input day (1-31 1-12 2010-2017)
#
#	All modes return matrix storing hourly averages of generation data. Each column is the type of generation:
#	For avgRenew it is in the order of: Geothermal, Biomass, Biogas, Small Hydro, Wind Total, Solar PV, Solar Thermal
#	For avgAll it is in the order of: Renewables, Nuclear, Thermal, Imports, Hydro
#	Each row is the hour 1-24.

import requests, csv, sys, datetime
import numpy as np

# Checks to see if a string is a number                                              
def is_number(s):
	try:
		int(s)
		return True
	except ValueError:
		return False


# Process one webpage for one day and return array of hourly values for each type of generation
def processDay (year, month, day):
	# 20170619 = date format in url
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
	
	# Put date into url format
	date = str(year) + monthstr + daystr

	url = "http://content.caiso.com/green/renewrpt/" + str(date) + "_DailyRenewablesWatch.txt"

	# Get page 
	page = requests.get(url)

	if page.status_code == requests.codes.ok: # Test to make sure url worked
		f = open('data.txt', 'r+') # Create text file to write page content to
		f.write(str(page.content)) # Write page content to text file
		f.close()
		
		# Create matrices to store data
		# Renewables = np.zeros((24, 7))
		# All = np.zeros((24, 5))
		# avgRenew = np.zeros((24, 7))
		# avgAll = np.zeros((24, 5)) 

		array = np.zeros((24, 16))

		# Initialize variables to 0
		rowCount = 0
		lineCount = 0

		# geothermal = int(0)
		# biomass = int(0)
		# biogas = int(0)
		# smallHydro = int(0)
		# windTotal = int(0)
		# solarPV = int(0)
		# solarThermal = int(0)

		# renewablesTotal = int(0)
		# nuclear = int(0)
		# thermal = int(0)
		# imports = int(0)
		# hydro = int(0)
		
		# Page formatting changed after 2012
		if (year == 2012 and month < 12) or (year < 2012):
			rColumnsLimit = 14
		else:
			rColumnsLimit = 16

		# Read data into matrices
		with open("data.txt") as input:
			for line in csv.reader(input, delimiter="\t"): # Read each line and separate by tabs
				# Reset count and isEmpty flag
				columnCount = 0;
				isEmpty = 0
				# First table of data (Renewable sources)
				if lineCount > 1 and lineCount < 26:
					for x in range(2,rColumnsLimit):
						if (line[x] != '' and line[x] != None): # Test if there is a value at x
							if is_number(line[x]):	# Test if value is a number
								#print "-------"
								#print rowCount, columnCount, line[x]
								# Renewables[rowCount][columnCount] = int(line[x])
								array[rowCount][0] = year
								array[rowCount][1] = month
								array[rowCount][2] = day
								array[rowCount][3] = rowCount+1 # Hour
								array[rowCount][columnCount+4] = int(line[x])
								columnCount += 1
								isEmpty = 1
								#print Renewables[rowCount][columnCount]
								#print "-------"
							else:
								isEmpty = 0
								#print "-------"
								#print rowCount, x, "no data"
								#print "-------"
					if isEmpty == 1: # If isEmpty is false, increment rowCount
						rowCount += 1
				# Second table of data (All sources)
				if lineCount > 29 and lineCount < (30+24):
					for x in range(2,14):
						if (line[x] != '' and line[x] != None): # Test if there is a value at x
							
							if is_number(line[x]):
								#print "-------"
								#print rowCount - 25, columnCount, line[x]
								# All[rowCount-25][columnCount] = int(line[x])
								array[rowCount-24][columnCount+11] = int(line[x])
								columnCount += 1
								isEmpty = 1
								#print All[rowCount-25][columnCount]
								#print "-------"
							else: 
								isEmpty = 0
								#print "-------"
								#print rowCount, x, "no data"
								#print "-------"
					if isEmpty == 1: # If isEmpty is false, increment rowCount
						rowCount += 1
				lineCount += 1 # Increment lineCount
	
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

		# return Renewables, All
		return array
	else:
		# print ; print "NO DATA FOR: " + str(date); print ;
		# return np.empty(7), np.empty(5)
		return np.empty(24,16)

# Process one month and return hourly values averaged over the number of days
def processMonth( year, month ):
	# Initialize matrices
	# totalRenew = np.zeros((24,7))
	# totalAll = np.zeros((24,5))

	# avgRenew = np.zeros((24,7))
	# avgAll = np.zeros((24,5))


	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month
	currDay = now.day

	#print month
	isCounted = 1 # Flag for determining if month has already been counted, default is false
	
	if year == 2010: # Data begins on 4/20/2010
		if month == 4: # Finish April
			days = int(10)
			monthArray = processDay(year, month, 20) # Fencepost first array
			for d in range(21, 31): # Go up to but not including 31
				# Renew, All = processDay(year, month, d)
				dayArray = processDay(year, month, d)
				# if (Renew.all() != None and All.all() != None and dayArray.all() != None): # If processDay worked, add values to total matrices
				if (dayArray.all() != None): # If processDay worked, concatenate next day to monthArray
					monthArray = np.concatenate((monthArray, dayArray), axis=0)
					# for i in range(0, 24):
					# 	for j in range(0, 7):
					# 		totalRenew[i][j] += Renew[i][j]
					# 		monthArray[i*dayCount][j+4] = dayArray
					# 	for k in range(0, 5):
					# 		totalAll[i][k] += All[i][k]
			isCounted = 0 # Set flag to true

	elif year == currYear:
		if month == currMonth:  # Only go up to current day
			days = int(currDay)
			monthArray = processDay(year, month, 1) # Fencepost first array
			for d in range(2, currDay):
				# Renew, All = processDay(year, month, d)
				dayArray = processDay(year, month, d)
				# if (Renew.all() != None and All.all() != None):
				if (dayArray.all() != None): # If processDay worked, concatenate next day to monthArray
					monthArray = np.concatenate((monthArray, dayArray), axis=0)
					# for i in range(0, 24):
					# 	for j in range(0, 7):
					# 		totalRenew[i][j] += Renew[i][j]
					# 	for k in range(0, 5):
					# 		totalAll[i][k] += All[i][k]
			
	if month == 2:  # February has 28 days
		days = int(28)
		monthArray = processDay(year, month, 1) # Fencepost first array
		for d in range(2, 29):
			# Renew, All = processDay(year, month, d)
			dayArray = processDay(year, month, d)
			# if (Renew.all() != None and All.all() != None):
			if (dayArray.all() != None): # If processDay worked, concatenate next day to monthArray
				monthArray = np.concatenate((monthArray, dayArray), axis=0)
				# for i in range(0, 24):
				# 	for j in range(0, 7):
				# 		totalRenew[i][j] += Renew[i][j]
				# 	for k in range(0, 5):
				# 		totalAll[i][k] += All[i][k]

	elif month == 4 or month == 6 or month == 9 or month == 11: # Months with 30 days
		if isCounted == 1: # Testing for special case when month == 4 to make sure it isn't counted twice
			days = int(30)
			monthArray = processDay(year, month, 1) # Fencepost first array
			for d in range(2, 31):
				# Renew, All = processDay(year, month, d)
				dayArray = processDay(year, month, d)
				# if (Renew.all() != None and All.all() != None):
				if (dayArray.all() != None): # If processDay worked, concatenate next day to monthArray
					monthArray = np.concatenate((monthArray, dayArray), axis=0)
					# for i in range(0, 24):
					# 	for j in range(0, 7):
					# 		totalRenew[i][j] += Renew[i][j]
					# 	for k in range(0, 5):
					# 		totalAll[i][k] += All[i][k]
	else:  # Months with 31 days
		days = int(31)
		monthArray = processDay(year, month, 1) # Fencepost first array
		for d in range(2, 32):
			# Renew, All = processDay(year, month, d)
			dayArray = processDay(year, month, d)
			# if (Renew.all() != None and All.all() != None):
			if (dayArray.all() != None): # If processDay worked, concatenate next day to monthArray
				monthArray = np.concatenate((monthArray, dayArray), axis=0)
				# for i in range(0, 24):
				# 	for j in range(0, 7):
				# 		totalRenew[i][j] += Renew[i][j]
				# 	for k in range(0, 5):
				# 		totalAll[i][k] += All[i][k]
	# Average values
	# for l in range(0, 24):
	# 	for m in range(0, 7):
	# 		avgRenew[l][m] = totalRenew[l][m]/days
	# 	for n in range(0, 5):
	# 		avgAll[l][n] = totalAll[l][n]/days

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

	# return avgRenew, avgAll
	return monthArray

# Process one year and return hourly values averaged over the number of months
def processYear( year ):
	# totalRenew = np.zeros((24,7))
	# totalAll = np.zeros((24,5))

	# avgRenew = np.zeros((24,7))
	# avgAll = np.zeros((24,5))

	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month

	if year == currYear:  # Only go up to current month
		months = int(currMonth)
		yearArray = processMonth(year, 1) # Fencepost first array
		for m in range(2, months + 1):
			# Renew, All = processMonth(year, m)
			monthArray = processMonth(year, m)
			yearArray = np.concatenate((yearArray, monthArray), axis=0)
			# for i in range(0, 24):
			# 	for j in range(0, 7):
			# 		totalRenew[i][j] += Renew[i][j]
			# 	for k in range(0, 5):
			# 		totalAll[i][k] += All[i][k]

	elif year == 2010:  # Starts in April
		months = int(9)
		yearArray = processMonth(year, 4) # Fencepost first array
		for m in range(5, 13):  # Finish April
			# Renew, All = processMonth(year, m)
			monthArray = processMonth(year, m)
			yearArray = np.concatenate((yearArray, monthArray), axis=0)
			# for i in range(0, 24):
			# 	for j in range(0, 7):
			# 		totalRenew[i][j] += Renew[i][j]
			# 	for k in range(0, 5):
			# 		totalAll[i][k] += All[i][k]
	
	else:  # Average whole year
		months = int(12)
		yearArray = processMonth(year, 1) # Fencepost first array
		for m in range(2, 13):
			# Renew, All = processMonth(year, m)
			monthArray = processMonth(year, m)
			yearArray = np.concatenate((yearArray, monthArray), axis=0)
			# for i in range(0, 24):
			# 	for j in range(0, 7):
			# 		totalRenew[i][j] += Renew[i][j]
			# 	for k in range(0, 5):
			# 		totalAll[i][k] += All[i][k]
	
	# Calculate averages for the year
	# for l in range(0, 24):
	# 	for x in range(0, 7):
	# 		avgRenew[l][x] = totalRenew[l][x]/months
	# 	for n in range(0, 5):
	# 		avgAll[l][n] = totalAll[l][n]/months

	# print days
	# print "----------"
	# print avgRenew
	# print "----------"
	# print avgAll
	# print "----------"

	# return avgRenew, avgAll	
	return yearArray



### Main script ###
if len(sys.argv) < 2: # No input arguments, aggregate all data since 4/20/2010
	year = None
	month = None
	day = None
	print "No input arguments, compile all possible data"

elif len(sys.argv) == 2: # There is one argument for year
	year = int(sys.argv[1])	
	month = None
	day = None
	print "One input argument, compile all data for year " + str(year)
	
elif len(sys.argv) == 3: # There are two arguments, year, month
	year = int(sys.argv[1])
	month = int(sys.argv[2])
	day = None
	print "Two input arguments, compile all data for month " + str(month) + "/" + str(year)
	
elif len(sys.argv) == 4: # There are three arguments, year, month, day
	year = int(sys.argv[1])	
	month = int(sys.argv[2])
	day = int(sys.argv[3])
	print "Three input arguments, compile all data for date " + str(month) + "/" + str(day) + "/" + str(year)

else:
	sys.exit("Error: cannot input more than three arguments")

# Initialize matrices
# totalRenew = np.zeros((24,7))
# totalAll = np.zeros((24,5))

# avgRenew = np.zeros((24,7))
# avgAll = np.zeros((24,5))

now = datetime.datetime.now()

currYear = now.year
currMonth = now.month
currDay = now.day

if year == None:  # Aggregate all data
	# Start from 04/20/2010
	years = currYear - 2010 + 1
	totalArray = processYear(2010) # Fencepost first array
	for y in range(2011, currYear):
		# Renew, All = processYear(y)
		yearArray = processYear(y)
		totalArray = np.concatenate((totalArray, yearArray), axis=0)
		# for i in range(0, 24):
		# 	for j in range(0, 7):
		# 		totalRenew[i][j] += Renew[i][j]
		# 	for k in range(0, 5):
		# 		totalAll[i][k] += All[i][k]
	# for l in range(0, 24):
	# 	for x in range(0, 7):
	# 		avgRenew[l][x] = totalRenew[l][x]/years
	# 	for n in range(0, 5):
	# 		avgAll[l][n] = totalAll[l][n]/years

elif month == None:  # Aggregate data for the year
	# avgRenew, avgAll = processYear(year)
	totalArray = processYear(year)
		
elif day == None:  # Aggregate data for the month
	# avgRenew, avgAll = processMonth(year, month)
	totalArray = processMonth(year, month)
	
elif year == currYear and month == currMonth and day == currDay:  
	sys.exit("Error: cannot calculate average for today")

elif year < 2010:
	sys.exit("Error: No data available before 2010")

else:  # Aggregate data for the day
	# avgRenew, avgAll = processDay(year, month, day)
	totalArray = processDay(year, month, day)
	

# Average values over 24 hours
# rAverage = np.mean(totalRenew, axis=0)
# aAverage = np.mean(totalAll, axis=0)

# # Prepare format for csv (year, month, day, hour, GEO, BIOM, BIOG, SMHY, WT, SPV, STH, REN, NUC, TH, IMP, HYD)
# final1 = np.zeros((24,4))

# for hour in range(0, 24):
# 	final1[hour][0] = year
# 	final1[hour][1] = month
# 	final1[hour][2] = day
# 	final1[hour][3] = hour + 1

# final2 = np.concatenate((final1, avgRenew), axis=1)

# final = np.concatenate((final2, avgAll), axis=1)



# Store results in csv file
with open('results.csv', 'wb') as csvfile:
		fileWriter = csv.writer(csvfile, delimiter=',')
		for row in range(0,24):
			fileWriter.writerow(totalArray[row])



# Print single averaged value
#print "Average Geothermal = " + str(rAverage[0])
#print "Average Biomass = " + str(rAverage[1])
#print "Average Biogas = " + str(rAverage[2])
#print "Average Small Hydro = " + str(rAverage[3])
#print "Average Wind Total = " + str(rAverage[4])
#print "Average Solar PV = " + str(rAverage[5])
#print "Average Solar Thermal = " + str(rAverage[6])
#print ;
#print "Average Renewables = " + str(aAverage[0])
#print "Average Nuclear = " + str(aAverage[1])
#print "Average Thermal = " + str(aAverage[2])
#print "Average Imports = " + str(aAverage[3])
#print "Average Hydro = " + str(aAverage[4])
#print

# Print averaged value for each hour for each source
# print "Average Geothermal = " + str(Renew[:,0])
# print "Average Biomass = " + str(Renew[:,1])
# print "Average Biogas = " + str(Renew[:,2])
# print "Average Small Hydro = " + str(Renew[:,3])
# print "Average Wind Total = " + str(Renew[:,4])
# print "Average Solar PV = " + str(Renew[:,5])
# print "Average Solar Thermal = " + str(Renew[:,6])
# print ;
# print "Average Renewables = " + str(All[:,0])
# print "Average Nuclear = " + str(All[:,1])
# print "Average Thermal = " + str(All[:,2])
# print "Average Imports = " + str(All[:,3])
# print "Average Hydro = " + str(All[:,4])


# Should print formatted matrix for averaged Renewables
# for row in avgRenew:
#     for val in row:
#         print '{:6}'.format(val),
#     print

# print

# # Should print formatted matrix for averaged All sources
# for row in avgAll:
#     for val in row:
#         print '{:4}'.format(val),
#     print

