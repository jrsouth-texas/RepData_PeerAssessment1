# Reproducible Research: Peer Assessment 1


### Loading and preprocessing the data


**The assumption for this exercise is that the datafile is in the same directory as the R markdown file.** 

We start by reading in the datafile and verifying that it has the full set of 17,568 observations.  


```r
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

The variables in the dataset are:

  - steps - the number of steps taken in 5-minute intervals (missing values are coded as NA)
  
  - date  - the date the measurements were taken in YYYY-MM-DD format
  
  - interval - Identifier for the 5-minute interval in wqhich the measurement was taken
  
The data are formatted numeric (steps, interval) and factors (date) after being read into a dataframe.  We also notice from the head() and tail() functions that there are some NA's in the steps variable.  



### What is mean total number of steps taken per day?

For this part, we want to answer several question of the data. We will ignore the missing values in the dataset.


1. Calculate the total number of steps taken per day
2. Make a histogram of the total number of steps taken each day.
3. Calculate and report the mean and median of the total number of steps taken per day.

To calculate the total numebr of step, we'l use aggregate(), passing it the sum function.  We'll store the results in a table, totalSteps  with to variables, tDate and tSteps.




```r
totalDays <- aggregate(afile$steps, by = list(afile$date), FUN = sum, na.rm=TRUE)
colnames(totalDays) <- c("tDate", "tSteps")
```

We can now plot this a histogram against the frequency of the number of steps taken on any given day.  


```r
hist(totalDays$tSteps,
     breaks=25,
     main = "Histogram of Total Steps per day",
     xlim=range(0,25000),
     col = "lightblue")
```

![](PA1_South_files/figure-html/unnamed-chunk-4-1.png) 

Finally, we want the the mean and median of otal number of steps taken per day.  


```r
meanSteps <- round(mean(totalDays$tSteps), digits=2)
print(paste(c("The mean of the total steps taken per day is: "), meanSteps))
```

```
## [1] "The mean of the total steps taken per day is:  9354.23"
```

```r
medianSteps <- round(median(totalDays$tSteps), digits=2)
print(paste(c("The median of the total steps taken per day is: "), medianSteps))
```

```
## [1] "The median of the total steps taken per day is:  10395"
```

### What is the average daily activity pattern?

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

We set up a table that computes the average number of steps per 5-minute interval. Then, we produce a time-series plot of of the average number of steps per interval. 


```r
intervalTable <- aggregate(afile$steps ~ afile$interval, FUN=mean)
colnames(intervalTable) <- c("interval", "steps")
plot(intervalTable$interval, intervalTable$steps, type="l",
     main="Time Series Plot of Average Number of Steps per 5-minute Interval",
     xlab="Interval", ylab="Steps")
```

![](PA1_South_files/figure-html/unnamed-chunk-6-1.png) 



2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
mInterval <- subset(intervalTable, steps == max(steps), select=interval )
maxInterval <- mInterval$interval[1]
```

```
## [1] "The interval with the most avarage number of steps per day is interval: 835"
```

### Imputing missing values

As noted in the first section of this exercise, there are number of days with intervals where there were no step data available.  Though we could assign a value of 0 for those intervals, a more legitimate strategy would be to take the average step values that we computed per interval per day and apply those to the corresponding intervas that have missing values. 


```
## [1] "The number of NA data points in our activity file is: 2304"
```

In order to not change the original data, we'll copy the original acitivity file to a new file, bfile, and then impute the new values for the data points that presently have NA values.  Then we'll use the table of averages as a look-up table where we can use the interval number from the impacted data point to look into our table of means and then replace the NA steps with a rounded number of steps from the value of the mean of all steps in that interval.  


```r
bfile <- afile
for (i in 1:nrow(bfile)){
   if(is.na(bfile$steps[i])) {
       bfile$steps[i] <- round(intervalTable[which(bfile$interval[i] == intervalTable$interval),]$steps)
       }
}
```

if we test again to see how many NA data points we have, we should see 0 NA values at this point. 


```
## [1] "The number of NA data points in our activity file is: 0"
```

WE wantg to make a histogram of the total number of steps taken each day and calculate and report the mean and median total number of steps taken per day. We can then determine if these values differ from the estimates from the first part of this exercise.   What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
newTotalDays <- aggregate(bfile$steps ~ bfile$date, FUN = sum, na.rm=TRUE)
colnames(newTotalDays) <- c("tDate", "tSteps")
str(newTotalDays)
```

```
## 'data.frame':	61 obs. of  2 variables:
##  $ tDate : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ tSteps: num  10762 126 11352 12116 13294 ...
```

```r
nrow(newTotalDays)
```

```
## [1] 61
```

```r
head(newTotalDays)
```

```
##        tDate tSteps
## 1 2012-10-01  10762
## 2 2012-10-02    126
## 3 2012-10-03  11352
## 4 2012-10-04  12116
## 5 2012-10-05  13294
## 6 2012-10-06  15420
```

We can now plot this a histogram against the frequency of the number of steps taken on any given day.  


```r
hist(newTotalDays$tSteps,
     breaks=25,
     main = "Histogram of Total Steps per day",
     xlim=range(0,25000),
     col = "lightblue")
```

![](PA1_South_files/figure-html/unnamed-chunk-13-1.png) 

Finally, we want the the mean and median of otal number of steps taken per day.  


```r
newMeanSteps <- round(mean(newTotalDays$tSteps), digits=2)
print(paste("The previous mean of the total steps taken per day was", meanSteps, "whereas the mean of with the imputed data is: ", newMeanSteps))
```

```
## [1] "The previous mean of the total steps taken per day was 9354.23 whereas the mean of with the imputed data is:  10765.64"
```

```r
newMedianSteps <- round(median(newTotalDays$tSteps), digits=2)
print(paste("The previous median of the total steps taken per day was: ", medianSteps, "whereas the median with the imputed date is:", newMedianSteps))
```

```
## [1] "The previous median of the total steps taken per day was:  10395 whereas the median with the imputed date is: 10762"
```

### Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

For the fourth, and final objective, we will be determining if there is any difference in the activity patterns of our user.  There are two stesp in this process:

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

To determine if the day of the week is a weekday or a weekend day, we'll apply the weekdays() function against a new dataframe that uses the aggregate() to calculate a mean of all of the days.  We'll build a new vector called, "dayType" which we will then append to the end of our newActivtyDays dataframe.  


```r
dayVector <-NULL

for (i in 1:nrow(bfile)) {
    dayVector[i] <- ifelse(weekdays(as.Date(bfile$date[i])) == "Saturday" |
                        weekdays(as.Date(bfile$date[i])) == "Sunday", "weekend", "weekday")
    }
activityDays <- cbind(bfile, as.factor(dayVector))
colnames(activityDays) <- c("steps", "date", "interval", "dayType")
str(activityDays)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps   : num  2 0 0 0 0 2 1 1 0 1 ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
##  $ dayType : Factor w/ 2 levels "weekday","weekend": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
table(activityDays$dayType)
```

```
## 
## weekday weekend 
##   12960    4608
```

We can move into the final objective which is creating a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 


```r
newMeansTable <- aggregate(activityDays$steps, 
                      list(interval = activityDays$interval, 
                           weekdays = activityDays$dayType),
                      FUN = mean)
names(newMeansTable)[3] <- "stepMeans"
library(lattice)
myPlot <- xyplot(newMeansTable$stepMeans ~ newMeansTable$interval | newMeansTable$weekdays, 
       layout = c(1, 2), type = "l", 
       xlab = "Interval", ylab = "Number of steps")
print(myPlot)
```

![](PA1_South_files/figure-html/unnamed-chunk-16-1.png) 

### Summary

We can see from the plot that the activity file indicates signifcantly more activity during weekends.  The plots show many more peaksabove 100 steps per interval during the weekwends.  
