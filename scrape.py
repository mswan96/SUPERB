#!/usr/bin/env python2


# scrape.py
# Megan Swanson
# SUPERB 
# 14.8.2017
#
#	Compiles hourly energy generation data from CAISO based on type of generation into csv file named "results.csv".
#	http://www.caiso.com/market/Pages/ReportsBulletins/DailyRenewablesWatch.aspx
#	Four different modes: 
#		No input: compiles all available data from start(04/20/2010) to the day
#			  before the current date.
#		One input: compiles all available data for the input year (2010-2017)
#		Two inputs: compiles all available data for the input month (1-12 2010-2017)
#		Three inputs: compiles all available data for the input day (1-31 1-12 2010-2017)
#
#	All modes return matrix storing hourly amounts of generation data. Format for columns is as follows:
#	Year, month, day, hour, Geothermal, Biomass, Biogas, Small Hydro, Wind Total, Solar PV, Solar Thermal, Renewables, Nuclear, Thermal, Imports, Hydro
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
		f = open('data.txt', 'w+') # Create text file to write page content to
		f.write(str(page.content)) # Write page content to text file
		f.close()
		
		# Create array to store data
		array = np.zeros((24, 16))

		# Initialize variables to 0
		rowCount = 0
		lineCount = 0

		# Page formatting changed after 2012
		if (year == 2012 and month < 12) or (year < 2012):
			rColumnsLimit = 14
		else:
			rColumnsLimit = 16

		# Read data into array
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
								array[rowCount][0] = year
								array[rowCount][1] = month
								array[rowCount][2] = day
								array[rowCount][3] = rowCount+1 # Hour
								array[rowCount][columnCount+4] = int(line[x])
								columnCount += 1
								isEmpty = 1
							else:
								isEmpty = 0
					if isEmpty == 1: # If isEmpty is false, increment rowCount
						rowCount += 1
				# Second table of data (All sources)
				if lineCount > 29 and lineCount < (30+24):
					for x in range(2,14):
						if (line[x] != '' and line[x] != None): # Test if there is a value at x
							
							if is_number(line[x]):
								array[rowCount-24][columnCount+11] = int(line[x])
								columnCount += 1
								isEmpty = 1
							else: 
								isEmpty = 0
					if isEmpty == 1: # If isEmpty is false, increment rowCount
						rowCount += 1
				lineCount += 1 # Increment lineCount

		return array
	else: # url did not work, no data for that day
		return np.empty(24,16)

# Process one month and return data for all days in the month
def processMonth( year, month ):
	
	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month
	currDay = now.day

	isCounted = 1 # Flag for determining if month has already been counted, default is false
	
	if year == 2010: # Data begins on 4/20/2010
		if month == 4: # Finish April
			days = int(10)
			monthArray = processDay(year, month, 20) # Fencepost first array
			for d in range(21, 31): # Go up to but not including 31
				dayArray = processDay(year, month, d)
				if (dayArray.all() != None): # If processDay worked, append next day to monthArray
					monthArray = np.append(monthArray, dayArray, axis=0)
			isCounted = 0 # Set flag to true

	elif year == currYear:
		if month == currMonth:  # Only go up to current day
			days = int(currDay)
			monthArray = processDay(year, month, 1) # Fencepost first array
			for d in range(2, currDay):
				dayArray = processDay(year, month, d)
				if (dayArray.all() != None): # If processDay worked, append next day to monthArray
					monthArray = np.append(monthArray, dayArray, axis=0)
			
	if month == 2:  # February has 28 days
		days = int(28)
		monthArray = processDay(year, month, 1) # Fencepost first array
		for d in range(2, 29):
			dayArray = processDay(year, month, d)
			if (dayArray.all() != None): # If processDay worked, append next day to monthArray
				monthArray = np.append(monthArray, dayArray, axis=0)

	elif month == 4 or month == 6 or month == 9 or month == 11: # Months with 30 days
		if isCounted == 1: # Testing for special case when month == 4 to make sure it isn't counted twice
			days = int(30)
			monthArray = processDay(year, month, 1) # Fencepost first array
			for d in range(2, 31):
				dayArray = processDay(year, month, d)
				if (dayArray.all() != None): # If processDay worked, append next day to monthArray
					monthArray = np.append(monthArray, dayArray, axis=0)
					
	else:  # Months with 31 days
		days = int(31)
		monthArray = processDay(year, month, 1) # Fencepost first array
		for d in range(2, 32):
			dayArray = processDay(year, month, d)
			if (dayArray.all() != None): # If processDay worked, append next day to monthArray
				monthArray = np.append(monthArray, dayArray, axis=0)
	
	return monthArray

# Process one year and return all data for the year
def processYear( year ):

	now = datetime.datetime.now()

	currYear = now.year
	currMonth = now.month

	if year == currYear:  # Only go up to current month
		months = int(currMonth)
		yearArray = processMonth(year, 1) # Fencepost first array
		for m in range(2, months + 1):
			monthArray = processMonth(year, m)
			yearArray = np.append(yearArray, monthArray, axis=0)

	elif year == 2010:  # Starts in April
		months = int(9)
		yearArray = processMonth(year, 4) # Fencepost first array
		for m in range(5, 13):  # Finish April
			monthArray = processMonth(year, m)
			yearArray = np.append(yearArray, monthArray, axis=0)
	
	else:  # Compile the whole year
		months = int(12)
		yearArray = processMonth(year, 1) # Fencepost first array
		for m in range(2, 13):
			monthArray = processMonth(year, m)
			yearArray = np.append(yearArray, monthArray, axis=0)

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


now = datetime.datetime.now()

currYear = now.year
currMonth = now.month
currDay = now.day

if year == None:  # Aggregate all data
	# Start from 04/20/2010
	years = currYear - 2010 + 1
	totalArray = processYear(2010) # Fencepost first array
	for y in range(2011, currYear):
		yearArray = processYear(y)
		totalArray = np.append(totalArray, yearArray, axis=0)
		
elif month == None:  # Aggregate data for the year
	totalArray = processYear(year)
		
elif day == None:  # Aggregate data for the month
	totalArray = processMonth(year, month)
	
elif year == currYear and month == currMonth and day == currDay:  
	sys.exit("Error: Cannot compile data for today")

elif year < 2010:
	sys.exit("Error: No data available before 2010")

else:  # Aggregate data for the day
	totalArray = processDay(year, month, day)

# Compute number of rows in array
a = np.array(totalArray)
numRows = a.shape[0]
print "Number of columns = " + numRows

# Store results in csv file
with open('results.csv', 'wb') as csvfile:
		fileWriter = csv.writer(csvfile, delimiter=',')
		for row in range(0,numRows):
			fileWriter.writerow(totalArray[row])


