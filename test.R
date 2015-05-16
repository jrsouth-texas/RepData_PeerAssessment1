for (i in 1:nrow(bfile)){
   if(is.na(bfile$steps[i])) {}
       bfile$steps[i] <- round(intervalTable[which(bfile$interval[i] == intervalTable$interval),]$steps)
}

