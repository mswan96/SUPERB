# SUPERB PROJECT 2017

## swing.m

Each subsection is able to be run independently, meaning you don't have to run one before you run the other. Section 1 plots the disturbance and frequency responses of no control and each controller (not including DC&VI). Section 2 plots the controllers on the same figure for comparision and compares different values of parameters for each controller as well as a comparison of all controllers with optimal values. Section 3 plots the step responses of each controller with different values of the parameters and a comparison of the controllers with optimal values. This section also computes the steady state error and rise time of each controller variation. Section 4 creates the heatmaps for each controller in with varied inertia and parameter values.

## myswing.m

Swing equation function with no control.


## droopControl.m

Swing equation function with Droop Control variable.


## virtualInertia.m

Swing equation function with Virtual Inertia control variable.


## both.m

Swing equation function with both Droop Control and Virtual Inertia control variables.


## scrape.py

#### To run in terminal:
./scrape.py
./scrape.py year(2010-current year)
./scrape.py year(2010-current year) month(1-12)
./scrape.py year(2010-current year) month(1-12) day(1-31)
Returns two matrices containg the averaged hourly values for each generation source as formatted on the CAISO Renewables Output Data pages (i.e. http://content.caiso.com/green/renewrpt/20170813_DailyRenewablesWatch.txt). When run, the script should print the matrices formatted without row or column headings. Other printing methods are commented out such as printing the overall average for each source and printing the hourly averages row by row.
