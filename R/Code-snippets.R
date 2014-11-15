
## ----setup, include="false"----------------------------------------------
library(knitr)
set.seed(1)
opts_knit$set(root.dir='..')


## ------------------------------------------------------------------------
a <- 1; b <- 1.73; c <- "hello"; d <- FALSE; e <- "world"
a + b
!d
paste(c,e)
class(b)


## ------------------------------------------------------------------------
l <- list(a,b,c,d,e,pi)
str(l)
l[[6]]
l[1:2]


## ------------------------------------------------------------------------
named.list <- list(value=5,word="text",number=7.3)
str(named.list)
named.list$value; named.list[["number"]]
names(named.list)


## ------------------------------------------------------------------------
a <- c(1,2,3)
b <- c("Hello","World","From","A","Vector")
str(b)
d <- 1:17
str(d)


## ------------------------------------------------------------------------
# probably bad
a <- c(1,2,3); a <- c(a,4); a <- c(a,5); a
# probably bad and certainly funny-looking
a[length(a)+1] <- 6; a


## ------------------------------------------------------------------------
rep(1,3)
seq(17,23)
# good
a <- rep(0,5); a[4] <- 4; a[5] <- 5; a


## ----eval=FALSE----------------------------------------------------------
## help(seq)


## ------------------------------------------------------------------------
b <- rep(2.,5); d <- sample(c(TRUE,FALSE),5,replace=TRUE)
a*b
sin(a)
!d
a[d]


## ------------------------------------------------------------------------
a[2:4]; a[c(1,3,5)]
a[-c(1,2,3)]; a[a<3]


## ------------------------------------------------------------------------
a
a[length(a)+3] <- 9
a


## ------------------------------------------------------------------------
is.na(a) 
a[!is.na(a)]
a[is.na(a)] <- -1
a


## ------------------------------------------------------------------------
a[a==-1] <- NA
a
sum(a)
sum(a,na.rm=TRUE)


## ------------------------------------------------------------------------
A <- matrix(rnorm(9),nrow=3,ncol=3); b <- 1:3
class(A)
A
A %*% b
solve(A,b)


## ------------------------------------------------------------------------
t(A)
b
solve(A,b)


## ------------------------------------------------------------------------
B <- array(1:12,c(2,3,2))
class(B)
B


## ------------------------------------------------------------------------
data <- read.csv("data/idealgas/ideal-gas-fixedV-small.csv")
class(data); str(data)


## ------------------------------------------------------------------------
data[1:3,"vol"]
data[2,]
data$pres[4:5]


## ----eval=FALSE----------------------------------------------------------
## data[1,"vol"] <- 12


## ----eval=FALSE----------------------------------------------------------
## vol <- data$vol
## vol <- 2.*vol+1
## data$vol <- vol


## ----eval=FALSE----------------------------------------------------------
## a <- 1:5
## doubleVector <- function(x) { x <- x*2 }
## doubleVector2 <- function(x) { x*2 }
## a
## doubleVector(a)
## a
## a <- doubleVector2(a)
## a


## ----eval=TRUE-----------------------------------------------------------
a <- 1:5
doubleVector <- function(x) { x <- x*2 }
doubleVector2 <- function(x) { x*2 }

a
doubleVector(a)
a
a <- doubleVector(a)
a


## ------------------------------------------------------------------------
mean.n.rnorm <- function(n) {
  random.nums <- rnorm(n)
  mean(random.nums)
}
ns <- c(1,10,100,1000,10000)
lapply(ns, mean.n.rnorm)


## ------------------------------------------------------------------------
ns <- c(1,10,100,1000,10000)
random.nums <- lapply(ns, rnorm)
means <- lapply(random.nums, mean)
means


## ------------------------------------------------------------------------
ns <- c(1,10,100,1000,10000)
random.nums <- lapply(ns, rnorm)
means <- sapply(random.nums, mean)
means
means*means


## ------------------------------------------------------------------------
A <- matrix(1:9,nrow=3,ncol=3)
A
apply(A, MARGIN=1, max)  # max of each row
apply(A, MARGIN=2, max)  # max of each col


## ------------------------------------------------------------------------
A
apply(A, MARGIN=1:2, function(x) { x**2 })  # square of each item


## ------------------------------------------------------------------------
str(data)
tapply(data$temp, data$n, mean)  # mean temperature, binned by n


## ----eval=FALSE----------------------------------------------------------
## split(data$temp, data$n)


## ----eval=FALSE----------------------------------------------------------
## sort( sapply( ls(), function(x) { object.size(get(x))} ),decreasing=TRUE )


## ------------------------------------------------------------------------
gc(TRUE)
old.mem <- gc(TRUE)[,c(1:2,5:6)]
x <- rep(0.,(16*1024)**2)
xsize <- object.size(x)
xsize


## ------------------------------------------------------------------------
xsize
print(xsize,units="MB")
new.mem <- gc(TRUE)[,c(1:2,5:6)]
new.mem-old.mem


## ------------------------------------------------------------------------
rm(x)
final.mem <- gc(TRUE)[,c(1:2,5:6)]
final.mem
final.mem-old.mem


## ------------------------------------------------------------------------
trunc.gc <- function() { gc(TRUE)[,c(1:2,5:6)] }
orig.gc <- trunc.gc()
x <- rnorm(16*1024*1024)
s <- sum(x)
s
rm(x)
after.gc <- trunc.gc()
after.gc - orig.gc


## ------------------------------------------------------------------------
rnorm.sum <- function(n) {
  x <- rnorm(n)
  sum(x)
}
orig.gc <- trunc.gc()
rnorm.sum(16*1024*1024)
after.gc <- trunc.gc()
after.gc - orig.gc


## ------------------------------------------------------------------------
small.data <- read.csv("data/idealgas/ideal-gas-fixedT-small.csv")
small.data[1:2,]


## ----eval=FALSE----------------------------------------------------------
## data <- read.big.matrix("data/idealgas/ideal-gas-fixedT-large.csv", header=TRUE,
##                         backingfile="data/idealgas/ideal-gas-fixedT-large.bin",
##                         descriptorfile="ideal-gas-fixedT-large.desc")


## ------------------------------------------------------------------------
library(bigmemory, quiet=TRUE)
orig.gc <- trunc.gc()
data <- attach.big.matrix("data/idealgas/ideal-gas-fixedT-large.desc")
trunc.gc()-orig.gc


## ------------------------------------------------------------------------
data[1:2,]
system.time(min.p <- min(data[,"pres"]))
trunc.gc()-orig.gc


## ------------------------------------------------------------------------
min.p
system.time(max.p <- max(data[,"pres"]))
system.time(mean.t <- mean(data[,"temp"]))


## ------------------------------------------------------------------------
trunc.gc()-orig.gc


## ------------------------------------------------------------------------
system.time(sum.pv <- sum(data[,"pres"]*data[,"vol"]))
system.time(sum.nt <- sum(data[,"n"]*data[,"temp"]))
sum.pv/sum.nt


## ------------------------------------------------------------------------
trunc.gc()-orig.gc


## ------------------------------------------------------------------------
system.time(subset.data <- data[mwhich(data, cols=c("n","pres"), 
                                       vals=c(1.,101000.), comps="eq", op="AND"),])
class(subset.data)
fit <- lm(vol ~ temp, data=as.data.frame(subset.data))


## ------------------------------------------------------------------------
summary(fit)


## ------------------------------------------------------------------------
object.size(subset.data)
trunc.gc()-orig.gc


## ----eval=FALSE----------------------------------------------------------
## n <- 4*1024
## A <- matrix( rnorm(n*n), ncol=n, nrow=n )
## B <- matrix( rnorm(n*n), ncol=n, nrow=n )
## C <- A %*% B


## ------------------------------------------------------------------------
library(parallel, quiet=TRUE)
source("data/airline/read_airline.R")
jan2010 <- read.airline("data/airline/airOT201001.csv")
unique.planes <- mcparallel( length( unique( sort(jan2010$TAIL_NUM) ) ) ) 
median.elapsed <- mcparallel( median( jan2010$ACTUAL_ELAPSED_TIME, na.rm=TRUE ) )
ans <- mccollect( list(unique.planes, median.elapsed) )
ans


## ------------------------------------------------------------------------
system.time(fit1 <-  lm(DISTANCE ~ AIR_TIME, data=jan2010))
system.time(fit2 <-  lm(ARR_DELAY ~ DEP_DELAY, data=jan2010))


## ------------------------------------------------------------------------
parfits <- function() {
  pfit1 <- mcparallel(lm(DISTANCE ~ AIR_TIME, data=jan2010))
  pfit2 <- mcparallel(lm(ARR_DELAY ~ DEP_DELAY, data=jan2010))
  mccollect( list(pfit1, pfit2) )
}
system.time( parfits() )


## ------------------------------------------------------------------------
# columns listing various delay measures
delaycols <- c(18, 28, 40, 41, 42, 43, 44)
air2010 <- readRDS("data/airline/airOT2010.RDS")
ord.delays <- air2010[(air2010$ORIGIN=="ORD"), delaycols]
rm(air2010)
ord.delays <- ord.delays[(ord.delays$ARR_DELAY_NEW > 0),]
ord.delays <- ord.delays[complete.cases(ord.delays),]

system.time( serial.res   <- kmeans(ord.delays, centers=2, nstart=40) )
serial.res$betweenss


## ------------------------------------------------------------------------
do.n.kmeans <- function(n) { kmeans(ord.delays, centers=2, nstart=n) }
system.time( list.res <- lapply( rep(10,4), do.n.kmeans ) )

res <- sapply( list.res, function(x) x$tot.withinss )
lapply.res <- list.res[[which.min(res)]]
lapply.res$withinss


## ------------------------------------------------------------------------
system.time( list.res <- mclapply( rep(10,4), do.n.kmeans, mc.cores=4 ) )

res <- sapply( list.res, function(x) x$tot.withinss )
mclapply.res <- list.res[[which.min(res)]]
mclapply.res$tot.withinss


## ------------------------------------------------------------------------
res


## ------------------------------------------------------------------------
RNGkind("L'Ecuyer-CMRG")
mclapply( rep(1,4), rnorm, mc.cores=4, mc.set.seed=TRUE)


## ------------------------------------------------------------------------
do.kmeans.nclusters <- function(n) { kmeans(ord.delays, centers=n, nstart=10) }
time.it <- function(n) { system.time( res <- do.kmeans.nclusters(n)) }
lapply(1:4, time.it)


## ------------------------------------------------------------------------
system.time( res <- mclapply(1:4, time.it, mc.cores=2) )
system.time( res <- mclapply(1:4, time.it, mc.cores=2, mc.preschedule=FALSE) )


## ------------------------------------------------------------------------
get.hour <- function(timeInt) timeInt %/% 100
count.hours <- function(range) {
  counts <- rep(0,24)
  hours <- sapply(jan2010$DEP_TIME[range], get.hour)
  hist <- rle( sort(hours) )
  for (i in 1:length(hist$values)) {
    j <- hist$values[i] + 1
    if (j == 25) j = 1
    counts[j] <- hist$lengths[i]
  }
  counts
}


## ------------------------------------------------------------------------
system.time(scounts <- count.hours(1:nrow(jan2010)))
scounts


## ------------------------------------------------------------------------
nr <- nrow(jan2010)
ncores <- 4
chunks <- split(1:nr, rep(1:ncores, each=nr/ncores))
system.time(counts <- mclapply( chunks, count.hours, mc.cores=ncores) )


## ------------------------------------------------------------------------
str(counts)
Reduce("+", counts)


## ------------------------------------------------------------------------
fx <- function(x) x^5-x^3+x^2-1
maxn <- 1e6
system.time( res <- sapply(1:maxn, fx) )
system.time( res <- vapply(1:maxn, fx, 0.) )


## ------------------------------------------------------------------------
system.time( res <- pvec(1:maxn, fx, mc.cores=2) )
system.time( res <- pvec(1:maxn, fx, mc.cores=4) )
system.time( res <- mclapply(1:maxn, fx, mc.cores=4) )


## ----include=FALSE-------------------------------------------------------
# Get rid of the data up to this point
rm(list=ls())


## ----eval=FALSE----------------------------------------------------------
## library(parallel)
## cl <- makeCluster(nworkers,...)
## results1 <- clusterApply(cl, ...)
## results2 <- clusterApply(cl, ...)
## stopCluster(cl)


## ------------------------------------------------------------------------
library(parallel)
cl <- makeCluster(4)
clusterCall(cl, rnorm, 5)
stopCluster(cl)


## ----eval=FALSE----------------------------------------------------------
## clusterEvalQ(cl, {library(parallel); library(foreach); NULL} )


## ------------------------------------------------------------------------
delaycols <- c(18, 28, 40, 41, 42, 43, 44)

source("data/airline/read_airline.R")
jan2010 <- read.airline("data/airline/airOT201001.csv")
jan2010 <- jan2010[,delaycols]
jan2010 <- jan2010[complete.cases(jan2010),]
do.n.kmeans <- function(n) { kmeans(jan2010, centers=4, nstart=n) }

## ----eval=FALSE----------------------------------------------------------
## library(parallel)
## cl <- makeCluster(4)
## res <- clusterApply(cl, rep(5,4), do.n.kmeans)
## stopCluster(cl)

## ----eval=FALSE----------------------------------------------------------
## ##  Error in checkForRemoteErrors(val) :
## ##    4 nodes produced errors; first error: object 'jan2010' not found


## ------------------------------------------------------------------------
cl <- makeCluster(4)
system.time(clusterExport(cl, "jan2010"))
system.time(cares <- clusterApply(cl, rep(5,4), do.n.kmeans))
stopCluster(cl)
system.time( mcres <- mclapply(rep(5,4), do.n.kmeans, mc.cores=4) )


## ----eval=FALSE----------------------------------------------------------
## hosts <- c( rep("localhost",8), rep("gpc01", 2) )
## cl <- makePSOCKcluster(names=hosts)
## clusterCall(cl, rnorm, 5)
## clusterCall(cl, system, "hostname")
## stopCluster(cl)


## ------------------------------------------------------------------------
library(snow,quiet=TRUE)


## ------------------------------------------------------------------------
do.kmeans.nclusters <- function(n) { kmeans(jan2010, centers=n, nstart=10) }

cl <- makeCluster(2)
clusterExport(cl,"jan2010")
tm <- snow.time( clusterApply(cl, 1:6, do.kmeans.nclusters) )


## ------------------------------------------------------------------------
plot(tm)


## ------------------------------------------------------------------------
tm.lb <- snow.time(clusterApplyLB(cl, 1:6, do.kmeans.nclusters))
plot(tm.lb)
stopCluster(cl)


## ------------------------------------------------------------------------
jan2010 <- read.airline("data/airline/airOT201001.csv")
jan2010 <- jan2010[complete.cases(jan2010),]

get.hour <- function(timeInt) timeInt %/% 100
count.hours <- function(timesInt) {
  counts <- rep(0,24)
  hours <- sapply(timesInt, get.hour)
  hist <- rle( sort(hours) )
  for (i in 1:length(hist$values)) {
    j <- hist$values[i] + 1
    if (j == 25) j = 1
    counts[j] <- hist$lengths[i]
  }
  counts
}


## ------------------------------------------------------------------------
cl <- makeCluster(2)
clusterExport(cl,"get.hour")  # have to export _functions_, too.
datapieces <- clusterSplit(cl,jan2010$DEP_TIME)
str(datapieces)
ans <- clusterApply(cl, datapieces, count.hours)
Reduce("+", ans)


## ------------------------------------------------------------------------
stopCluster(cl)
cl <- makeCluster(6)
datapieces <- clusterSplit(cl,jan2010$DEP_TIME)
stopCluster(cl)

cl <- makeCluster(2)
clusterExport(cl,"get.hour")  # have to export _functions_, too.
str(datapieces)


## ------------------------------------------------------------------------
tm <- snow.time( ans <- clusterApply(cl, datapieces, count.hours) )
plot(tm)


## ------------------------------------------------------------------------
tm <- snow.time( ans <- parLapply(cl, datapieces, count.hours) )
plot(tm)
stopCluster(cl)


## ------------------------------------------------------------------------
detach("package:snow", unload=TRUE)


## ------------------------------------------------------------------------
for (i in 1:3) print(sqrt(i))


## ------------------------------------------------------------------------
library(foreach)
foreach (i=1:3) %do% sqrt(i)


## ----eval=FALSE----------------------------------------------------------
## library(foreach)
## foreach (i=1:3) %do% sqrt(i)


## ------------------------------------------------------------------------
library(doParallel)
registerDoParallel(3)  # use multicore-style forking
foreach (i=1:3) %dopar% sqrt(i)
stopImplicitCluster()


## ------------------------------------------------------------------------
cl <- makePSOCKcluster(3)
registerDoParallel(cl)  # use the just-made PSOCK cluster
foreach (i=1:3) %dopar% sqrt(i)
stopCluster(cl)


## ------------------------------------------------------------------------
foreach (i=1:3, .combine=c) %do% sqrt(i)
foreach (i=1:3, .combine=cbind) %do% sqrt(i)
foreach (i=1:3, .combine="+") %do% sqrt(i)
foreach (i=1:3, .multicombine=TRUE, .combine="sum") %do% sqrt(i)


## ------------------------------------------------------------------------
foreach (i=1:3, .combine="c") %:% 
  foreach (j=1:3, .combine="c") %do% {
    i*j
  }


## ------------------------------------------------------------------------
foreach (a=rnorm(25), .combine="c") %:%
  when(a >= 0) %do%
    sqrt(a)


## ------------------------------------------------------------------------
system.time(
  foreach (i=1:2000, .combine="+") %do% {
    hrs <- rep(0,24)
    hr <- get.hour(jan2010$DEP_TIME[i])
    hrs[hr+1] = hrs[hr+1] + 1
    hrs
  }
)


## ------------------------------------------------------------------------
cl <- makePSOCKcluster(3)
registerDoParallel(cl,cores=3)
system.time(
  foreach (i=1:2000, .combine="+") %dopar% {
    hrs <- rep(0,24)
    hr <- get.hour(jan2010$DEP_TIME[i])
    hrs[hr+1] = hrs[hr+1] + 1
    hrs
  }
)
stopCluster(cl)


## ------------------------------------------------------------------------
system.time(
  ans <- foreach (i=1:2000, .combine="+") %do% {
    hrs <- rep(0,24)
    hr <- get.hour(jan2010$DEP_TIME[i])
    hrs[hr+1] = hrs[hr+1] + 1
    hrs
  }
)
system.time(ans <- count.hours(jan2010$DEP_TIME[1:2000]))


## ----eval=FALSE----------------------------------------------------------
## system.time(
##   ans <- foreach (i=icount(2000), .combine="+") %do% {
##     hrs <- rep(0,24)
##     hr <- get.hour(jan2010$DEP_TIME[i])
##     hrs[hr+1] = hrs[hr+1] + 1
##     hrs
##   }
## )


## ----eval=FALSE----------------------------------------------------------
##  foreach (time=jan2010$DEP_TIME[1:2000],...


## ------------------------------------------------------------------------
system.time(
  ans <- foreach (time=iter(jan2010$DEP_TIME[1:2000],chunksize=500), .combine="+") %do% {
    hrs <- rep(0,24)
    hr <- get.hour(time)
    hrs[hr+1] = hrs[hr+1] + 1
    hrs
  }
)
ans


## ----eval=FALSE----------------------------------------------------------
## foreach( ..., .options.multicore=list(preschedule=FALSE,set.seed=TRUE))


## ------------------------------------------------------------------------
jan.matrix = matrix(jan2010$DEP_TIME[1:2000], ncol=500)
system.time(
  ans <- foreach (times=iter(jan.matrix,by="row"), .combine="+") %do% {
    count.hours(times)
  }
)
ans


## ------------------------------------------------------------------------
cl <- makePSOCKcluster(4)
registerDoParallel(cl,cores=4)
jan.matrix = matrix(jan2010$DEP_TIME[1:2000], ncol=500)
system.time(
  ans <- foreach (times=iter(jan.matrix,by="row"), .combine="+") %dopar% {
    count.hours(times)
  }
)
stopCluster(cl)
ans


## ------------------------------------------------------------------------
ans <- foreach (byAirline=isplit(jan2010$DEP_TIME, jan2010$UNIQUE_CARRIER), 
                .combine=cbind) %do% {
  df <- data.frame(count.hours(byAirline$value)); colnames(df) <- byAirline$key; df
}
ans$UA
ans$OH


## ------------------------------------------------------------------------
stocks <- read.csv("data/stocks//stocks.csv")
log.returns <- function(values) { nv=length(values); log(values[2:nv]/values[1:nv-1]) }


## ------------------------------------------------------------------------
registerDoParallel(4)
mat.log <- 
  foreach(col=iter(stocks[,-c(1,2)],by="col"), .combine="cbind")  %dopar% 
      log.returns(col)
stopImplicitCluster()

stocks.log <- as.data.frame(mat.log)
colnames(stocks.log) <- colnames(stocks)[-c(1,2)] 
stocks.log$date <- stocks$date[-1]   # get rid of the first day; no "return" for then


## ------------------------------------------------------------------------
nstocks <- 419
cors <- matrix(rep(0,nstocks*nstocks), nrow=nstocks, ncol=nstocks)
system.time(
for (i in 1:419) {
  for (j in 1:419) {
    cors[i,j] <- cor(stocks.log[[i]],stocks.log[[j]])    
  }
}
)


## ----eval=FALSE----------------------------------------------------------
## foreach(...) %:%
##   foreach(...)


## ------------------------------------------------------------------------
library(parallel)
library(Rdsm)

nrows <- 7

cl <- makePSOCKcluster(3)       # form 3-process PSOCK (share-nothing) cluster
init <- mgrinit(cl)             # initialize Rdsm
mgrmakevar(cl,"m",nrows,nrows)  # make a 7x7 shared matrix
bar <- makebarr(cl)


## ------------------------------------------------------------------------
# at each thread, set id to Rdsm built-in ID variable for that thread
clusterEvalQ(cl,myid <- myinfo$id)
clusterExport(cl,c("nrows"))
dmy <- clusterEvalQ(cl,myidxs <- getidxs(nrows))
dmy <- clusterEvalQ(cl, m[myidxs,1:nrows] <- myid)
dmy <- clusterEvalQ(cl,"barr()")


## ------------------------------------------------------------------------
print(m[,])
stoprdsm(cl)  # stops cluster


## ----eval=FALSE----------------------------------------------------------
## # count.hours and get.hour definitions...
## start.year <- 1990
## 
## init()
## rank <- comm.rank()
## my.year <- start.year + rank
## 
## myfile <- paste0("data/airline/airOT",as.character(my.year),".RDS")
## data <- readRDS(myfile); data <- data$DEP_TIME
## myhrs <- count.hours(data)
## 
## hrs <- allreduce( myhrs, op="sum" )
## comm.print( hrs )
## comm.print( sum(hrs) )
## 
## finalize()


## ----eval=FALSE----------------------------------------------------------
## # count.hours and get.hour definitions...
## start.year <- 1990
## 
## init()
## rank <- comm.rank()
## my.year <- start.year + rank
## 
## myfile <- paste0("data/airline/airOT",as.character(my.year),".RDS")
## data <- readRDS(myfile); data <- data$DEP_TIME


## ----eval=FALSE----------------------------------------------------------
## data <- readRDS(myfile); data <- data$DEP_TIME
## myhrs <- count.hours(data)
## 
## hrs <- allreduce( myhrs, op="sum" )
## comm.print( hrs )
## comm.print( sum(hrs) )
## 
## finalize()


## ----eval=FALSE----------------------------------------------------------
## init()
## rank <- comm.rank()
## my.year <- start.year + rank
## 
## myfile <- paste0("../data/airline/airOT",as.character(my.year),".RDS")
## data <- readRDS(myfile); data <- data$CRS_ELAPSED_TIME
## data <- data[!is.na(data)]
## 
## data.median <- pbd.quantile(data,0.5)
## data.min <- allreduce(min(data), op="min")
## data.max <- allreduce(max(data), op="max")
## data.N <- allreduce(length(data), op="sum")
## data.mean <- allreduce(sum(data), op="sum")/data.N
## 
## comm.print(data.min)
## comm.print(data.median)
## comm.print(data.mean)
## comm.print(data.max)
## 
## finalize()


## ----eval=FALSE----------------------------------------------------------
## pbd.quantile <- function( data, q=0.5 ) {
##     if (q < 0 | q > 1) {
##         stop("q should be between 0 and 1.")
##     }
## 
##     N <- allreduce(length(data), op="sum")
##     data.max <- allreduce(max(data), op="max")
##     data.min <- allreduce(min(data), op="min")
## 
##     f.quantile <- function(x, prob=0.5) {
##         allreduce(sum(data <= x), op="sum" )/N - prob
##     }
## 
##     uniroot(f.quantile, c(data.min, data.max), prob=q)$root
## }


## ----eval=FALSE----------------------------------------------------------
## year.hours <- function(my.year) {
##     myfile <- paste0("data/airline/airOT",as.character(my.year),".RDS")
##     data <- readRDS(myfile)$DEP_TIME
##     count.hours(data)
## }
## 
## init()
## years <- 1990:1993
## all.hours.list <- pbdLapply(years, year.hours)
## all.hours <- Reduce("+", all.hours.list)
## 
## comm.print( all.hours )
## comm.print( sum(all.hours) )
## 
## finalize()


## ----eval=FALSE----------------------------------------------------------
## init.grid()
## rank <- comm.rank()
## my.year <- start.year + rank
## 
## data <- cleandata(my.year)
## Y <- data[[1]]
## X <- as.matrix(data[,-1])
## 
## X.dm <- gbd2dmat(X)
## Y.dm <- gbd2dmat(Y)
## 
## fit <- lm(Y ~ X)
## comm.print(summary(fit))
## 
## finalize()


