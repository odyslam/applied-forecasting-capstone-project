library("ggplot2")
library("forecast")
library("fpp")

sampled <- read.csv("/Users/odys/Github/forecasting-course-project/sample_array.csv")
testd <- read.csv("/Users/odys/Github/forecasting-course-project/test_array.csv")


usable.data <- data.frame( 
  "airPassengers" = NA, 
  "power" = NA, 
  "wind" = NA
)

test.data <- data.frame( 
  "airPassengers" = NA, 
  "power" = NA, 
  "wind" = NA
)

for (item in dat[,1]){
  data = as.vector(strsplit(item, ";")[[1]])
  usable.data <- rbind(usable.data, data)
  
}

for (item in dat.test[,1]){
  data = as.vector(strsplit(item, ";")[[1]])
  test.data <- rbind(test.data, data)
  
}
usable.data <- usable.data[-1, ]
test.data <- test.data[-1, ]


air.ts = ts(sampled$sample_array, frequency = 7)
dec = decompose(air.ts, type = "multiplicative")

seasonality = dec$seasonal
trend = air.ts/seasonality

forecast1 = holt(trend, h = 150, type = "multiplicative")
forecast2 = forecast(ets(air.ts), h = 150)
forecast3 = holt(trend, h = 150, damped = TRUE, type = "multiplicative")

nfm = (forecast1$mean - testd$test_array)/ (forecast1$mean + testd$test_array)
# nfm = [-1, +1] -1 = underforecast, +1 = over-forecast
# 
aggregate(nfm)

out_sample = c(testd$test_array)
sqrt(mean(forecast1$fitted*seasonality - sampled$sample_array) ^2)
sqrt(mean(forecast1$mean*as.numeric(tail(seasonality, 150)) - out_sample) ^2)

sqrt(mean(forecast2$fitted*seasonality - sampled$sample_array) ^2)
sqrt(mean(forecast2$mean*as.numeric(tail(seasonality, 150)) - out_sample) ^2)

sqrt(mean(forecast3$fitted*seasonality - sampled$sample_array) ^2)
sqrt(mean(forecast3$mean*as.numeric(tail(seasonality, 150)) - out_sample) ^2)

pi.1 = forecast1$upper - forecast1$lower
pi.2 = forecast2$upper - forecast2$lower
pi.3 = forecast3$upper - forecast3$lower

between85 <- c()
between95 <- c()
count95 <- 0
count85 <- 0
true.percent95 <-b

for(i in seq_along(c(1:150)) ){
  low <- forecast1$lower[i,]*tail(seasonality,150)[i]
  high <- forecast1$upper[i,]*tail(seasonality,150)[i]
  test <- testd$test_array[i]
  between85[i] <- FALSE
  between95[i] <- FALSE
  if (low[1] < test && test < high[1]){
    between85[i] <- TRUE
    count85 <- count85 + 1
  }
  if (low[2] < test && test < high[2]){
    between95[i] <- TRUE
    count95 <- count95 + 1
  }
  
}
count85/150*100
count95/150*100

plot(as.numeric(testd$test_array), type = "l")
lines(as.numeric(forecast1$lower[,1]*as.numeric(tail(seasonality,150))), col = "red")
lines(as.numeric(forecast1$upper[,1]*as.numeric(tail(seasonality,150))), col = "blue")

