# Reproducible Research: Peer Assessment 1


### Loading and preprocessing the data


The assumption for this exercise is that the datafile is in the same directory as the R markdown file. We start by reading in the datafile and verifying that it has the full set of 17,568 observations.  


```r
# afile <- read.csv("activity.csv", as.is=TRUE)
afile <- read.csv("activity.csv")
nrow(afile)
```

```
## [1] 17568
```

```r
str(afile)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
head(afile)
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
tail(afile)
```

```
##       steps       date interval
## 17563    NA 2012-11-30     2330
## 17564    NA 2012-11-30     2335
## 17565    NA 2012-11-30     2340
## 17566    NA 2012-11-30     2345
## 17567    NA 2012-11-30     2350
## 17568    NA 2012-11-30     2355
```

```r
print("The number of steps NA's: "); sum(is.na(afile$steps))
```

```
## [1] "The number of steps NA's: "
```

```
## [1] 2304
```

```r
print("The number of date NA's: "); sum(is.na(afile$date))
```

```
## [1] "The number of date NA's: "
```

```
## [1] 0
```

```r
print("The number of interval NA's: "); sum(is.na(afile$interval))
```

```
## [1] "The number of interval NA's: "
```

```
## [1] 0
```

The variables in the dataset are:

  - steps - the number of steps taken in 5-minute intervals (missing values are coded as NA)
  
  - date  - the date the measurements were taken in YYYY-MM-DD format
  
  - interval - Identifier for the 5-minute interval in wqhich the measurement was taken
  
The data are formatted numeric (steps, interval) and factors (date) after being read into a dataframe.  We also notice from the head() and tail() functions that there are some NA's in the steps variable.  Since the date variable is coming in as a factor, we'll want to convert it to the class Date.


```r
## afile$date <- as.Date(afile$date)
```

## What is mean total number of steps taken per day?



## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
