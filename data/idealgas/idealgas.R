ideal.gas.fixedV <- function(presrange, nrange, vrange, tnoiseamp, tnoisesd) {
  gas.const <- 8.3144621
  
  npres <- length(presrange)
  nn <- length(nrange)
  nv <- length(vrange)
  
  pres <- rep(presrange,nn*nv)
  n    <- rep(nrange,each=npres*nv)
  vol  <- rep(vrange,nn,each=npres)
  
  temp <- pres*vol/(n*gas.const) + tnoiseamp*rnorm(nn*nv*npres,sd=tnoisesd)

  data <- data.frame(pres,vol,n,temp)   
}


ideal.gas.fixedT <- function(presrange, nrange, trange, vnoiseamp, vnoisesd) {
  gas.const <- 8.3144621
  
  npres <- length(presrange)
  nn <- length(nrange)
  nt <- length(trange)
  
  pres <- rep(presrange,nn*nt)
  n    <- rep(nrange,each=npres*nt)
  temp <- rep(trange,nn,each=npres)
  
  vol <- (n*gas.const*temp)/pres + vnoiseamp*rnorm(nn*nt*npres,sd=vnoisesd)
  
  data <- data.frame(pres,vol,n,temp)   
}

plarge <- seq(90000,110000,20000)
tlarge <- seq(280,320,400)
nlarge <- seq(.5,2.,15)

large <- ideal.gas.fixedT(plarge, nlarge, tlarge, 0.1, 0.1)
write.csv(large, "ideal-gsa-fixedT-large.csv",row.names=FALSE)
